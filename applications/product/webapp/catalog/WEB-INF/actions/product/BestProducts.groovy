/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import java.sql.Timestamp

import org.ofbiz.base.util.UtilDateTime
import org.ofbiz.entity.condition.EntityCondition
import org.ofbiz.entity.condition.EntityOperator
import org.ofbiz.product.product.ProductContentWrapper

//Map<String, Timestamp> intervalDates = UtilDateTime.getPeriodInterval(context.intervalPeriod, context.fromDate, context.locale, context.timeZone);
//context.dateBeginText = UtilDateTime.toDateString(intervalDates.get("dateBegin"));
//context.dateEndText = UtilDateTime.toDateString(intervalDates.get("dateEnd"));

int iCount = context.chartIntervalCount != null ? Integer.parseInt(context.chartIntervalCount) : 6;
String iScope = context.chartIntervalScope != null ? context.chartIntervalScope : "month"; //day|week|month|year

iCount = UtilDateTime.getIntervalDefaultCount(iScope);
fromDateTimestamp = UtilDateTime.getTimeStampFromIntervalScope(iScope, iCount);
dateIntervals = UtilDateTime.getPeriodIntervalAndFormatter(iScope, fromDateTimestamp, context.locale, context.timeZone);

bestSellingProducts = [];
exprList = [];
exprList.add(EntityCondition.makeCondition("orderDate", EntityOperator.GREATER_THAN_EQUAL_TO, dateIntervals.getDateBegin()));
exprList.add(EntityCondition.makeCondition("orderDate", EntityOperator.LESS_THAN_EQUAL_TO, dateIntervals.getDateEnd()));
exprList.add(EntityCondition.makeCondition("orderTypeId", EntityOperator.EQUALS, "SALES_ORDER"));
exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "ORDER_CANCELLED"));

orderHeaderList = from("OrderHeader").where(exprList).queryList();

orderHeaderList.each { orderHeader ->
    exprList.clear();
    exprList.add(EntityCondition.makeCondition("orderId", orderHeader.orderId));
    exprList.add(EntityCondition.makeCondition("orderItemTypeId", "PRODUCT_ORDER_ITEM"));
    exprList.add(EntityCondition.makeCondition("isPromo", "N"));
    exprList.add(EntityCondition.makeCondition("statusId", EntityOperator.NOT_EQUAL, "ITEM_CANCELLED"));

    orderItemList = from("OrderItem").where(exprList).queryList();

    orderItemList.each { orderItem ->
        orderItemDetail = [:];
        qtyOrdered = BigDecimal.ZERO;
        qtyOrdered += orderItem.quantity;
        if (orderItem.cancelQuantity) {
            qtyOrdered -= orderItem.cancelQuantity;
        }
        amount = BigDecimal.ZERO;;
        amount = qtyOrdered * orderItem.unitPrice;
        inListFlag = false
        
        bestSellingProducts.each { bestSellingProduct ->
            if ((bestSellingProduct.productId).equals(orderItem.productId) && (bestSellingProduct.currencyUom).equals(orderHeader.currencyUom)) {
                inListFlag = true;
                bestSellingProduct.amount += amount;
                bestSellingProduct.qtyOrdered += qtyOrdered;
            }
        }
        
        if (inListFlag == false) {
            orderItemDetail.productId = orderItem.productId;
            product = from("Product").where("productId", orderItem.productId).queryOne()
            contentWrapper = new ProductContentWrapper(product, request);
            // Scipo: Do NOT HTML-escape this here
            orderItemDetail.productName = contentWrapper.get("PRODUCT_NAME", "raw").toString();
            orderItemDetail.amount = amount;
            orderItemDetail.qtyOrdered = qtyOrdered;
            orderItemDetail.currencyUom = orderHeader.currencyUom;
            bestSellingProducts.add(orderItemDetail);
        }
    }
}

// Sorting List
topSellingProducts = [];
itr = 1;
while (itr <= 5) {
    orderItemDetail = [:];
    bestSellingProducts.each { bestSellingProduct ->
        if (!(orderItemDetail.isEmpty())) {
            if (bestSellingProduct.qtyOrdered > orderItemDetail.qtyOrdered) {
                orderItemDetail = bestSellingProduct;
            }
            if (bestSellingProduct.qtyOrdered == orderItemDetail.qtyOrdered && bestSellingProduct.amount > orderItemDetail.amount) {
                orderItemDetail = bestSellingProduct;
            }
        } else {
            orderItemDetail = bestSellingProduct;
        }
    }
    if (!orderItemDetail.isEmpty()) {
        if (orderItemDetail.amount) {
            orderItemDetail.amount = orderItemDetail.amount.setScale(2, BigDecimal.ROUND_HALF_UP);
        }
        topSellingProducts.add(orderItemDetail);
        bestSellingProducts.remove(orderItemDetail);
    }
    itr++;
}

context.bestSellingProducts = topSellingProducts;

context.now = UtilDateTime.toDateString(UtilDateTime.nowDate());
