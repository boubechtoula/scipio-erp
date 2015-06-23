<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<script language="JavaScript" type="text/javascript">
    function editInstruction(shipGroupSeqId) {
        jQuery('#shippingInstructions_' + shipGroupSeqId).css({display:'block'});
        jQuery('#saveInstruction_' + shipGroupSeqId).css({display:'inline'});
        jQuery('#editInstruction_' + shipGroupSeqId).css({display:'none'});
        jQuery('#instruction_' + shipGroupSeqId).css({display:'none'});
    }
    function addInstruction(shipGroupSeqId) {
        jQuery('#shippingInstructions_' + shipGroupSeqId).css({display:'block'});
        jQuery('#saveInstruction_' + shipGroupSeqId).css({display:'inline'});
        jQuery('#addInstruction_' + shipGroupSeqId).css({display:'none'});
    }
    function saveInstruction(shipGroupSeqId) {
        jQuery("#updateShippingInstructionsForm_" + shipGroupSeqId).submit();
    }
    function editGiftMessage(shipGroupSeqId) {
        jQuery('#giftMessage_' + shipGroupSeqId).css({display:'block'});
        jQuery('#saveGiftMessage_' + shipGroupSeqId).css({display:'inline'});
        jQuery('#editGiftMessage_' + shipGroupSeqId).css({display:'none'});
        jQuery('#message_' + shipGroupSeqId).css({display:'none'});
    }
    function addGiftMessage(shipGroupSeqId) {
        jQuery('#giftMessage_' + shipGroupSeqId).css({display:'block'});
        jQuery('#saveGiftMessage_' + shipGroupSeqId).css({display:'inline'});
        jQuery('#addGiftMessage_' + shipGroupSeqId).css({display:'none'});
    }
    function saveGiftMessage(shipGroupSeqId) {
        jQuery("#setGiftMessageForm_" + shipGroupSeqId).submit();
    }
</script>

<#if shipGroups?has_content && (!orderHeader.salesChannelEnumId?? || orderHeader.salesChannelEnumId != "POS_SALES_CHANNEL")>
  <#if parameters.view?has_content && parameters.view = "OISGA">
<#-- TODO: Convert to Foundation: New in Ofbiz 14.12 -->
  <div class="screenlet">
     <div class="screenlet-title-bar">
        <ul>
           <li class="h3">&nbsp;${uiLabelMap.OrderShipmentInformation}</li>
           <li><a href="<@ofbizUrl>orderview?orderId=${orderId}</@ofbizUrl>">${uiLabelMap.OrderShipmentInformationByOISG}</a></li>
        </ul>
        <br class="clear"/>
     </div>
     <div class="screenlet-body">
      <table width="100%" cellspacing="0" cellpadding="2" border="1" class="basic-table">
          <tr class="header-row">
              <td width="10%">${uiLabelMap.OrderItemId}</td>
              <td width="25%">${uiLabelMap.ProductProduct}</td>
              <td width="10%">${uiLabelMap.CommonQuantity}</td>
              <td width="40%">${uiLabelMap.ProductQuantityNotAvailable}</td>
              <td width="5%"> </td>
          </tr>
          <#assign index = 0>
          <#list orderItemDatas as orderItemData>
              <#assign orderItem = orderItemData.orderItem>
              <#assign OISGAssContents = orderItemData.OISGAssContents>
              <#assign product = orderItemData.product!>
              <#assign quantityOrdered = orderItemData.quantityOrdered?default(0)>
              <#assign totalQuantityToPlan = orderItemData.totalQuantityToPlan>
              <#assign quantityNotAvailable = orderItemData.quantityNotAvailable>
              <#assign rowCount = 0>

              <#if index != 0>
          <tr><td colspan="4"><hr/></td></tr>
              </#if>
              <#if (quantityOrdered > 0) >
          <tr id="tableevenrow">
              <td><div><a name="orderItem${index}">${orderItem.orderItemSeqId}</a></div></td>
              <td><div>${product.internalName!} [<a href="/catalog/control/EditProduct?productId=${orderItem.productId!}" class="link">${orderItem.productId!}</a>]</div></td>
              <td><div>${quantityOrdered}</div></td>
              <td><div>${quantityNotAvailable}</div></td>
              <td>
                  <#if !orderItem.statusId?exists || orderItem.statusId == "ITEM_CREATED" || orderItem.statusId == "ITEM_APPROVED">
                  <div class="tabletext" id="display${index}">
                      <a name="display${index}" href="javascript: showEdit('edit', '${index}');" class="smallSubmit"> ${uiLabelMap.CommonEdit}</a>
                  </div>
                  <div class="tabletext" id="edit${index}" style="display: none">
                      <a style="float: left;" href="javascript: document.UpdateOrderItemShipGroupAssoc${index}.submit()" class="smallSubmit">${uiLabelMap.CommonValidate}</a>
                      <a style="float: left;" href="javascript:showEdit('display', '${index}'); restoreEditField('${index}');" class="smallSubmit">${uiLabelMap.CommonCancel}</a>
                  </div>
                  </#if>
              </td>
              <td class="tableList"></td>
          </tr>
          <tr><td colspan="4"><hr/></td></tr>
              <form method="post" action="<@ofbizUrl>UpdateOrderItemShipGroupAssoc?view=OISGA</@ofbizUrl>" name="UpdateOrderItemShipGroupAssoc${index}"/>
                  <input type="hidden" name="orderId" value="${orderId}"/>
                  <input type="hidden" name="orderItemSeqId" value="${orderItem.orderItemSeqId}"/>
                  <#list OISGAssContents as OISGAssContent>
                      <#assign OISG = OISGAssContent.getRelatedOne("OrderItemShipGroup")>
                      <#assign orderShipments = OISGAssContent.getRelated("OrderShipment")>
          <tr>
              <input name="_rowSubmit_o_${rowCount}" value="Y" type="hidden">
              <input type="hidden" name="orderId_o_${rowCount}" value="${orderId}"/>
              <input type="hidden" name="orderItemSeqId_o_${rowCount}" value="${orderItem.orderItemSeqId}"/>
              <input type="hidden" name="shipGroupSeqId_o_${rowCount}" value="${OISG.shipGroupSeqId}"/>
              <input type="hidden" name="rowCount_o_${rowCount}" value="${rowCount}"/>
              <td colspan="2">&nbsp;</td>
              <td colspan="2">
                  <div class="tabletext"> [${OISG.shipGroupSeqId}] <#if OISG.shipByDate?has_content>, ${uiLabelMap.OrderShipBeforeDate} : ${OISG.shipByDate?date}</#if></div>
                      <#if orderType == "SALES_ORDER">
                          <#list orderShipments as orderShipment>
                  <div>${uiLabelMap.OrderPlannedInShipment} : </b><a target="facility" href="/facility/control/ViewShipment?shipmentId=${orderShipment.shipmentId!}&externalLoginKey=${externalLoginKey}" class="button tiny" style="font-size: xx-small;">${orderShipment.shipmentId!}</a>:${orderShipment.shipmentItemSeqId!} - ${orderShipment.quantity!}</div>
                          </#list>
                      <#elseif orderType == "PURCHASE_ORDER">
                          <#list orderShipments as orderShipment>
                              <#if orderShipment.quantity?has_content & orderShipment.quantity!=0.0 >
                  <div>${uiLabelMap.OrderPlannedInReceive} : </b><a target="facility" href="/facility/control/ViewReceiveShipment?shipmentId=${orderShipment.shipmentId!}&externalLoginKey=${externalLoginKey}" class="button tiny" style="font-size: xx-small;">${orderShipment.shipmentId!}</a>:${orderShipment.shipmentItemSeqId!} - ${orderShipment.quantity!}</div>
                              <#else>
                                  <#assign shipmentItem = orderShipment.getShipmentItem()>
                  <div>${uiLabelMap.OrderPlannedRejected} : </b><a target="facility" href="/facility/control/ViewReceiveShipment?shipmentId=${orderShipment.shipmentId!}&externalLoginKey=${externalLoginKey}" class="button tiny" style="font-size: xx-small;">${orderShipment.shipmentId!}</a>:${orderShipment.shipmentItemSeqId!} - ${shipmentItem.quantity!}</div>
                              </#if>
                          </#list>
                      </#if>
              </td>
              <td class="tableList">
                  <div id="displayQuantity${index}${rowCount}" class="tabletext">${OISGAssContent.quantity!}</div>
                      <#if (orderShipments.size()?default(0)) == 0>
                  <div id="editQuantity${index}${rowCount}" style="display: none;"><input id="edit${index}_o_${rowCount}" name="quantity_o_${rowCount}" size="5" value="${OISGAssContent.quantity!}" title="${OISGAssContent.quantity!}" class="inputBox"/></div>
                      <#else>
                  <div id="editQuantity${index}${rowCount}" style="display: none;">${OISGAssContent.quantity!}</div>
                  <input type="hidden" name="quantity_o_${rowCount}" value="${OISGAssContent.quantity!}"/>
                      </#if>
              </td>
          </tr>
                      <#assign rowCount = rowCount + 1> 
                  </#list>
              <input type="hidden" name="_rowCount" value="${rowCount}"/>
              </form>
                  <#if !orderItem.statusId?exists || orderItem.statusId == "ITEM_CREATED" || orderItem.statusId == "ITEM_APPROVED" && (orderHeader.statusId != "ORDER_SENT" && orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_REJECTED" && orderHeader.statusId != "ORDER_CANCELLED")>
          <tr>
              <form method="post" action="<@ofbizUrl>AddOrderItemShipGroupAssoc?view=OISGA</@ofbizUrl>" name="addOISGForm${index}"/>
              <input type="hidden" name="editQuantity" value="edit"/>
              <input type="hidden" name="editQuantityIndex" value="${index}"/>
              <input type="hidden" name="orderId" value="${orderId}"/>
              <input type="hidden" name="orderItemSeqId" value="${orderItem.orderItemSeqId}"/>
              <input type="hidden" name="quantity" value="0"/>
              <td colspan="3" class="tableList">&nbsp;</td>
              <td class="tableList">
                  <table class="basic-table" cellspacing='0'>
                      <tr>
                          <td>
                             <div class="label">${uiLabelMap.OrderAddToshipGroup} : </div>
                             <div>
                                 <select name="shipGroupSeqId" class="selectBox" onChange="showShipByDate(this, 'shipByDate${index}')">
                      <#list shipGroups as shipGroup>
                                     <option value="${shipGroup.shipGroupSeqId}">[${shipGroup.shipGroupSeqId}]<#if shipGroup.shipByDate?has_content>, ${shipGroup.shipByDate?date}</#if></option>
                      </#list>
                                     <option value="new">${uiLabelMap.CommonNew}</option>
                                 </select>
                             </div>
                         </td>
                         <td class="tableList"></td>
                     </tr>
                     <tr>
                         <td>
                             <div style="display:none" id="shipByDate${index}">
                                 <span class="tabletext">${uiLabelMap.OrderShipBeforeDate}</span>
                                 <span class="view-calendar"><@htmlTemplate.renderDateTimeField name="shipByDate" event="" action="" value="${requestParameters.maxDate!}" className="" alert="" title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="shipByDate_${index}" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/></span>
                             </div>
                         </td>
                     </tr>
                     <tr>
                         <td>
                             <span class="tabletext">
                                 <a href="javascript:document.addOISGForm${index}.submit()" class="smallSubmit">${uiLabelMap.CommonAdd}</a>
                             </span>
                         </td>
                     </tr>
                 </table>
             </td>
             </form>
         </tr>
                  </#if>
              </#if>
              <#assign index = index + 1>
          </#list>
      </table>
    </div>
  </div>
<#else>
<#list shipGroups as shipGroup>
  <#assign shipmentMethodType = shipGroup.getRelatedOne("ShipmentMethodType", false)!>
  <#assign shipGroupAddress = shipGroup.getRelatedOne("PostalAddress", false)!>
    <@section title="${uiLabelMap.OrderShipmentInformation} - ${shipGroup.shipGroupSeqId}">
       <ul class="button-group">
         <li class="expanded"><a onclick="javascript:toggleScreenlet(this, 'ShipGroupScreenletBody_${shipGroup.shipGroupSeqId}', 'true', '${uiLabelMap.CommonExpand}', '${uiLabelMap.CommonCollapse}');" title="Collapse">&nbsp;</a></li>
         <li><a target="_BLANK" class="button tiny" href="<@ofbizUrl>shipGroups.pdf?orderId=${orderId}&amp;shipGroupSeqId=${shipGroup.shipGroupSeqId}</@ofbizUrl>">${uiLabelMap.OrderShipGroup} PDF</a></li>
         <#-- Foundation: Button migrated from removed header to access OISGA -->
         <#if !parameters.view?has_content>
           <li><a href="<@ofbizUrl>orderview?orderId=${orderId}&amp;view=OISGA</@ofbizUrl>" class="button tiny">${uiLabelMap.OrderShipmentInformationByOrderItem}</a></li>
         </#if>
       </ul>

    <div id="ShipGroupScreenletBody_${shipGroup.shipGroupSeqId}">
          <form name="updateOrderItemShipGroup" method="post" action="<@ofbizUrl>updateShipGroupShipInfo</@ofbizUrl>">
        <input type="hidden" name="orderId" value="${orderId!}"/>
        <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId!}"/>
        <input type="hidden" name="contactMechPurposeTypeId" value="SHIPPING_LOCATION"/>
        <input type="hidden" name="oldContactMechId" value="${shipGroup.contactMechId!}"/>
        <table class="basic-table" cellspacing='0'>
                <tr>
                    <td scope="row" class="${style_grid_large!}3">
                        ${uiLabelMap.OrderAddress}
                    </td>
                    <td width="5">&nbsp;</td>
                    <td valign="top" width="80%">
                        <div>
                            <#if orderHeader?has_content && orderHeader.statusId != "ORDER_CANCELLED" && orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_REJECTED">
                            <select name="contactMechId">
                                <option selected="selected" value="${shipGroup.contactMechId!}">${(shipGroupAddress.address1)?default("")} - ${shipGroupAddress.city?default("")}</option>
                                <#if shippingContactMechList?has_content>
                                <option disabled="disabled" value=""></option>
                                <#list shippingContactMechList as shippingContactMech>
                                <#assign shippingPostalAddress = shippingContactMech.getRelatedOne("PostalAddress", false)!>
                                <#if shippingContactMech.contactMechId?has_content>
                                <option value="${shippingContactMech.contactMechId!}">${(shippingPostalAddress.address1)?default("")} - ${shippingPostalAddress.city?default("")}</option>
                                </#if>
                                </#list>
                                </#if>
                            </select>
                            <#else>
                            ${(shipGroupAddress.address1)?default("")}
                            </#if>
                        </div>
                    </td>
                </tr>

                <#-- the setting of shipping method is only supported for sales orders at this time -->
                <#if orderHeader.orderTypeId == "SALES_ORDER">
                  <tr>
                    <td scope="row" class="${style_grid_large!}3">
                        <b>${uiLabelMap.CommonMethod}</b>
                    </td>
                    <td width="5">&nbsp;</td>
                    <td valign="top" width="80%">
                        <div>
                            <#if orderHeader?has_content && orderHeader.statusId != "ORDER_CANCELLED" && orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_REJECTED">
                            <#-- passing the shipmentMethod value as the combination of three fields value
                            i.e shipmentMethodTypeId & carrierPartyId & roleTypeId. Values are separated by
                            "@" symbol.
                            -->
                            <select name="shipmentMethod">
                                <#if shipGroup.shipmentMethodTypeId?has_content>
                                  <option value="${shipGroup.shipmentMethodTypeId}@${shipGroup.carrierPartyId!}@${shipGroup.carrierRoleTypeId!}"><#if shipGroup.carrierPartyId?? && shipGroup.carrierPartyId != "_NA_">${shipGroup.carrierPartyId!}</#if>&nbsp;${shipmentMethodType.get("description",locale)!}</option>
                                </#if>
                                  <#list shipGroupShippingMethods[shipGroup.shipGroupSeqId] as productStoreShipmentMethod>
                                  <#assign shipmentMethodTypeAndParty = productStoreShipmentMethod.shipmentMethodTypeId + "@" + productStoreShipmentMethod.partyId + "@" + productStoreShipmentMethod.roleTypeId>
                                  <#if productStoreShipmentMethod.partyId?has_content || productStoreShipmentMethod?has_content>
                                    <option value="${shipmentMethodTypeAndParty!}"><#if productStoreShipmentMethod.partyId != "_NA_">${productStoreShipmentMethod.partyId!}</#if>&nbsp;${productStoreShipmentMethod.get("description",locale)?default("")}</option>
                                  </#if>
                                </#list>
                            </select>
                            <#else>
                                <#if (shipGroup.carrierPartyId)?default("_NA_") != "_NA_">
                                    ${shipGroup.carrierPartyId!}
                                </#if>
                                <#if shipmentMethodType?has_content>
                                    ${shipmentMethodType.get("description",locale)?default("")}
                                </#if>
                            </#if>
                        </div>
                    </td>
                  </tr>
                </#if>
                <#if orderHeader?has_content && orderHeader.statusId != "ORDER_CANCELLED" && orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_REJECTED">
                <tr>
                    <td scope="row" class="${style_grid_large!}3">&nbsp;</td>
                    <td width="5">&nbsp;</td>
                    <td valign="top" width="80%">
                        <input type="submit" value="${uiLabelMap.CommonUpdate}" class="smallSubmit"/>
                        <a class="button tiny" id="newShippingAddress" href="javascript:void(0);">${uiLabelMap.OrderNewShippingAddress}</a>
                        <script type="text/javascript">
                            jQuery("#newShippingAddress").click(function(){jQuery("#newShippingAddressForm").dialog("open")});
                        </script>
                    </td>
                </tr>
                </#if>
                <#if !shipGroup.contactMechId?has_content && !shipGroup.shipmentMethodTypeId?has_content>
                <#assign noShipment = "true">
                <tr>
                    <td colspan="3" align="center">${uiLabelMap.OrderNotShipped}</td>
                </tr>
                </#if>
      </table>
      </form>
      </div>
      <div id="newShippingAddressForm" class="popup" style="display: none;">
        <form id="addShippingAddress" name="addShippingAddress" method="post" action="addShippingAddress">
          <input type="hidden" name="orderId" value="${orderId!}"/>
          <input type="hidden" name="partyId" value="${partyId!}"/>
          <input type="hidden" name="oldContactMechId" value="${shipGroup.contactMechId!}"/>
          <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId!}"/>
          <input type="hidden" name="contactMechPurposeTypeId" value="SHIPPING_LOCATION"/>
          <div class="form-row">
            <label for="address1">${uiLabelMap.PartyAddressLine1}*</label>
            <div class="form-field"><input type="text" class="required" name="shipToAddress1" id="address1" value="" size="30" maxlength="30" /></div>
          </div>
          <div class="form-row">
            <label for="address2">${uiLabelMap.PartyAddressLine2}</label>
            <div class="form-field"><input type="text" name="shipToAddress2" id="address2" value="" size="30" maxlength="30" /></div>
          </div>
          <div class="form-row">
            <label for="city">${uiLabelMap.PartyCity}* </label>
            <div class="form-field"><input type="text" class="required" name="shipToCity" id="city" value="" size="30" maxlength="30" /></div>
          </div>
          <div class="form-row">
            <label for="postalCode">${uiLabelMap.PartyZipCode}* </label>
            <div class="form-field"><input type="text" class="required number" name="shipToPostalCode" id="postalCode" value="" size="30" maxlength="10" /></div>
          </div>
          <div class="form-row">
            <label for="countryGeoId">${uiLabelMap.CommonCountry}* </label>
            <div class="form-field">
              <select name="shipToCountryGeoId" id="countryGeoId" class="required">
                <#if countryGeoId??>
                  <option value="${countryGeoId}">${countryGeoId}</option>
                </#if>
                ${screens.render("component://common/widget/CommonScreens.xml#countries")}
              </select>
            </div>
          </div>
          <div class="form-row">
            <label for="stateProvinceGeoId">${uiLabelMap.PartyState}* </label>
            <div class="form-field">
              <select name="shipToStateProvinceGeoId" id="stateProvinceGeoId">
                <#if stateProvinceGeoId?has_content>
                  <option value="${stateProvinceGeoId}">${stateProvinceGeoId}</option>
                <#else>
                  <option value="_NA_">${uiLabelMap.PartyNoState}</option>
                </#if>
              </select>
            </div>
          </div>
          <div class="form-row">
            <input id="submitAddShippingAddress" type="button" value="${uiLabelMap.CommonSubmit}" style="display:none"/>
            <form action="">
              <input class="popup_closebox button tiny" type="button" value="${uiLabelMap.CommonClose}" style="display:none"/>
            </form>
          </div>
        </form>
      </div>
      <script language="JavaScript" type="text/javascript">
       jQuery(document).ready( function() {
        jQuery("#newShippingAddressForm").dialog({autoOpen: false, modal: true,
                buttons: {
                '${uiLabelMap.CommonSubmit}': function() {
                    var addShippingAddress = jQuery("#addShippingAddress");
                    jQuery("<p>${uiLabelMap.CommonUpdatingData}</p>").insertBefore(addShippingAddress);
                    addShippingAddress.submit();
                },
                '${uiLabelMap.CommonClose}': function() {
                    jQuery(this).dialog('close');
                    }
                }
                });
       });
      </script>
      <table  cellspacing="0" class="basic-table">
        <#if shipGroup.supplierPartyId?has_content>
           <#assign OISGAContent = shipGroup.getRelated("OrderItemShipGroupAssoc")>
           <#-- New in Ofbiz 14.12 -->
           <#if OISGAContent.size() == 0>
           <tr>
              <td colspan="3" valign="top" width="100%" align="center">
                   <a href="javascript:document.deleteOISG_${shipGroup.shipGroupSeqId}.submit()" class="button tiny">${uiLabelMap.DeleteOrderItemShipGroup}</a>
                   <form name="deleteOISG_${shipGroup.shipGroupSeqId}" method="post" action="/ordermgr/control/DeleteOrderItemShipGroup">
                     <input type="hidden" name="orderId" value="${orderId}"/>
                     <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                   </form>
              </td>
           </tr>
           </#if>
          <tr>
            <td scope="row" class="${style_grid_large!}3">
              ${uiLabelMap.ProductDropShipment} - ${uiLabelMap.PartySupplier}
            </td>
            <td width="5">&nbsp;</td>
            <td valign="top" width="80%">
              ${Static["org.ofbiz.party.party.PartyHelper"].getPartyName(delegator, shipGroup.supplierPartyId, false)!shipGroup.supplierPartyId}
            </td>
          </tr>
        </#if>

        <#-- This section appears when Shipment of order is in picked status and its items are packed,this case comes when new shipping estimates based on weight of packages are more than or less than default percentage (defined in shipment.properties) of original shipping estimate-->
        <#-- getShipGroupEstimate method of ShippingEvents class can be used for get shipping estimate from system, on the basis of new package's weight -->
        <#if shippingRateList?has_content>
          <#if orderReadHelper.getOrderTypeId() != "PURCHASE_ORDER">
  
            <tr>
              <td colspan="3">
                <table>
                  <tr>
                    <td>
                      ${uiLabelMap.OrderOnlineUPSShippingEstimates}
                    </td>
                  </tr>
                  <form name="UpdateShippingMethod" method="post" action="<@ofbizUrl>updateShippingMethodAndCharges</@ofbizUrl>">
                    <#list shippingRateList as shippingRate>
                      <tr>
                        <td>
                          <#assign shipmentMethodAndAmount = shippingRate.shipmentMethodTypeId + "@" + "UPS" + "*" + shippingRate.rate>
                          <input type='radio' name='shipmentMethodAndAmount' value='${shipmentMethodAndAmount!}' />
                          UPS&nbsp;${shippingRate.shipmentMethodDescription!}
                          <#if (shippingRate.rate > -1)>
                            <@ofbizCurrency amount=shippingRate.rate isoCode=orderReadHelper.getCurrency()/>
                          <#else>
                            ${uiLabelMap.OrderCalculatedOffline}
                          </#if>
                        </td>
                      </tr>
                    </#list>
                    <input type="hidden" name="shipmentRouteSegmentId" value="${shipmentRouteSegmentId!}"/>
                    <input type="hidden" name="shipmentId" value="${pickedShipmentId!}"/>
                    <input type="hidden" name="orderAdjustmentId" value="${orderAdjustmentId!}"/>
                    <input type="hidden" name="orderId" value="${orderId!}"/>
                    <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId!}"/>
                    <input type="hidden" name="contactMechPurposeTypeId" value="SHIPPING_LOCATION"/>
                    <input type="hidden" name="oldContactMechId" value="${shipGroup.contactMechId!}"/>
                    <input type="hidden" name="shippingAmount" value="${shippingAmount!}"/>
                    <tr>
                      <td valign="top" width="80%">
                        <input type="submit" value="${uiLabelMap.CommonUpdate}" class="smallSubmit"/>
                      </td>
                    </tr>
                  </form>
                </table>
              </td>
            </tr>
          </#if>
        </#if>

        <#-- tracking number -->
        <#if shipGroup.trackingNumber?has_content || orderShipmentInfoSummaryList?has_content>

          <tr>
            <td scope="row" class="${style_grid_large!}3">
              ${uiLabelMap.OrderTrackingNumber}
            </td>
            <td width="5">&nbsp;</td>
            <td valign="top" width="80%">
              <#-- TODO: add links to UPS/FEDEX/etc based on carrier partyId  -->
              <#if shipGroup.trackingNumber?has_content>
                ${shipGroup.trackingNumber}
              </#if>
              <#if orderShipmentInfoSummaryList?has_content>
                <#list orderShipmentInfoSummaryList as orderShipmentInfoSummary>
                  <#if orderShipmentInfoSummary.shipGroupSeqId! == shipGroup.shipGroupSeqId!>
                    <div>
                      <#if (orderShipmentInfoSummaryList?size > 1)>${orderShipmentInfoSummary.shipmentPackageSeqId}: </#if>
                      ${uiLabelMap.CommonIdCode}: ${orderShipmentInfoSummary.trackingCode?default("[${uiLabelMap.OrderNotYetKnown}]")}
                      <#if orderShipmentInfoSummary.boxNumber?has_content> ${uiLabelMap.ProductBox} #${orderShipmentInfoSummary.boxNumber}</#if>
                      <#if orderShipmentInfoSummary.carrierPartyId?has_content>(${uiLabelMap.ProductCarrier}: ${orderShipmentInfoSummary.carrierPartyId})</#if>
                    </div>
                  </#if>
                </#list>
              </#if>
            </td>
          </tr>
        </#if>
        <#if shipGroup.maySplit?has_content && noShipment?default("false") != "true">

          <tr>
            <td scope="row" class="${style_grid_large!}3">
              ${uiLabelMap.OrderSplittingPreference}
            </td>
            <td width="5">&nbsp;</td>
            <td valign="top" width="80%">
              <div>
                <#if shipGroup.maySplit?upper_case == "N">
                    ${uiLabelMap.FacilityWaitEntireOrderReady}
                    <#if security.hasEntityPermission("ORDERMGR", "_UPDATE", session)>
                      <#if orderHeader.statusId != "ORDER_COMPLETED" && orderHeader.statusId != "ORDER_CANCELLED">
                        <form name="allowordersplit_${shipGroup.shipGroupSeqId}" method="post" action="<@ofbizUrl>allowordersplit</@ofbizUrl>">
                          <input type="hidden" name="orderId" value="${orderId}"/>
                          <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                        </form>
                        <a href="javascript:document.allowordersplit_${shipGroup.shipGroupSeqId}.submit()" class="button tiny">${uiLabelMap.OrderAllowSplit}</a>
                      </#if>
                    </#if>
                <#else>
                    ${uiLabelMap.FacilityShipAvailable}
                </#if>
              </div>
            </td>
          </tr>
        </#if>


        <tr>
          <td scope="row" class="${style_grid_large!}3">
            ${uiLabelMap.OrderInstructions}
          </td>
          <td width="5">&nbsp;</td>
          <td align="left" valign="top" width="80%">
            <#if (!orderHeader.statusId.equals("ORDER_COMPLETED")) && !(orderHeader.statusId.equals("ORDER_REJECTED")) && !(orderHeader.statusId.equals("ORDER_CANCELLED"))>
              <form id="updateShippingInstructionsForm_${shipGroup.shipGroupSeqId}" name="updateShippingInstructionsForm" method="post" action="<@ofbizUrl>setShippingInstructions</@ofbizUrl>">
                <input type="hidden" name="orderId" value="${orderHeader.orderId}"/>
                <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                <#if shipGroup.shippingInstructions?has_content>
                  <table>
                    <tr>
                      <td id="instruction">
                        <label>${shipGroup.shippingInstructions}</label>
                      </td>
                      <td>
                        <a href="javascript:editInstruction('${shipGroup.shipGroupSeqId}');" class="button tiny" id="editInstruction_${shipGroup.shipGroupSeqId}">${uiLabelMap.CommonEdit}</a>
                      </td>
                    </tr>
                  </table>
                <#else>
                  <a href="javascript:addInstruction('${shipGroup.shipGroupSeqId}');" class="button tiny" id="addInstruction_${shipGroup.shipGroupSeqId}">${uiLabelMap.CommonAdd}</a>
                </#if>
                <a href="javascript:saveInstruction('${shipGroup.shipGroupSeqId}');" class="button tiny" id="saveInstruction_${shipGroup.shipGroupSeqId}" style="display:none">${uiLabelMap.CommonSave}</a>
                <textarea name="shippingInstructions" id="shippingInstructions_${shipGroup.shipGroupSeqId}" style="display:none" rows="0" cols="0">${shipGroup.shippingInstructions!}</textarea>
              </form>
            <#else>
              <#if shipGroup.shippingInstructions?has_content>
                ${shipGroup.shippingInstructions}
              <#else>
                ${uiLabelMap.OrderThisOrderDoesNotHaveShippingInstructions}
              </#if>
            </#if>
          </td>
        </tr>

        <#if shipGroup.isGift?has_content && noShipment?default("false") != "true">

        <tr>
          <td scope="row" class="${style_grid_large!}3">
            ${uiLabelMap.OrderGiftMessage}
          </td>
          <td width="5">&nbsp;</td>
          <td>
            <form id="setGiftMessageForm_${shipGroup.shipGroupSeqId}" name="setGiftMessageForm" method="post" action="<@ofbizUrl>setGiftMessage</@ofbizUrl>">
              <input type="hidden" name="orderId" value="${orderHeader.orderId}"/>
              <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
              <#if shipGroup.giftMessage?has_content>
                <label>${shipGroup.giftMessage}</label>
                <a href="javascript:editGiftMessage('${shipGroup.shipGroupSeqId}');" class="button tiny" id="editGiftMessage_${shipGroup.shipGroupSeqId}">${uiLabelMap.CommonEdit}</a>
              <#else>
                <a href="javascript:addGiftMessage('${shipGroup.shipGroupSeqId}');" class="button tiny" id="addGiftMessage_${shipGroup.shipGroupSeqId}">${uiLabelMap.CommonAdd}</a>
              </#if>
              <textarea name="giftMessage" id="giftMessage_${shipGroup.shipGroupSeqId}" style="display:none" rows="0" cols="0">${shipGroup.giftMessage!}</textarea>
              <a href="javascript:saveGiftMessage('${shipGroup.shipGroupSeqId}');" class="button tiny" id="saveGiftMessage_${shipGroup.shipGroupSeqId}" style="display:none">${uiLabelMap.CommonSave}</a>
            </form>
          </td>
        </tr>
        </#if>

         <tr>
            <td scope="row" class="${style_grid_large!}3">
              ${uiLabelMap.OrderShipAfterDate}<br/>
              ${uiLabelMap.OrderShipBeforeDate}
            </td>
            <td width="5">&nbsp;</td>
            <td valign="top" width="80%">
              <form name="setShipGroupDates_${shipGroup.shipGroupSeqId}" method="post" action="<@ofbizUrl>updateOrderItemShipGroup</@ofbizUrl>">
                <input type="hidden" name="orderId" value="${orderHeader.orderId}"/>
                <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                <@htmlTemplate.renderDateTimeField alert="false" name="shipAfterDate" event="" action="" value="${shipGroup.shipAfterDate!}" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="shipAfterDate_${shipGroup.shipGroupSeqId}" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                <br/>
                <@htmlTemplate.renderDateTimeField alert="false" name="shipByDate" event="" action="" value="${shipGroup.shipByDate!}" className=""  title="Format: yyyy-MM-dd HH:mm:ss.SSS" size="25" maxlength="30" id="shipByDate_${shipGroup.shipGroupSeqId}" dateType="date" shortDateInput=false timeDropdownParamName="" defaultDateTimeString="" localizedIconTitle="" timeDropdown="" timeHourName="" classString="" hour1="" hour2="" timeMinutesName="" minutes="" isTwelveHour="" ampmName="" amSelected="" pmSelected="" compositeType="" formName=""/>
                <input type="submit" value="${uiLabelMap.CommonUpdate}"/>
                </form>
            </td>
         </tr>
       <#assign shipGroupShipments = shipGroup.getRelated("PrimaryShipment", null, null, false)>
       <#if shipGroupShipments?has_content>

          <tr>
            <td scope="row" class="${style_grid_large!}3">
              ${uiLabelMap.FacilityShipments}
            </td>
            <td width="5">&nbsp;</td>
            <td valign="top" width="80%">
                <#list shipGroupShipments as shipment>
                    <div>
                      ${uiLabelMap.CommonNbr}<a href="/facility/control/ViewShipment?shipmentId=${shipment.shipmentId}${StringUtil.wrapString(externalKeyParam)}" >${shipment.shipmentId}</a>&nbsp;&nbsp;
                      <a target="_BLANK" href="/facility/control/PackingSlip.pdf?shipmentId=${shipment.shipmentId}${StringUtil.wrapString(externalKeyParam)}" class="button tiny">${uiLabelMap.ProductPackingSlip}</a>
                      <#if "SALES_ORDER" == orderHeader.orderTypeId && "ORDER_COMPLETED" == orderHeader.statusId>
                        <#assign shipmentRouteSegments = delegator.findByAnd("ShipmentRouteSegment", {"shipmentId" : shipment.shipmentId}, null, false)>
                        <#if shipmentRouteSegments?has_content>
                          <#assign shipmentRouteSegment = Static["org.ofbiz.entity.util.EntityUtil"].getFirst(shipmentRouteSegments)>
                          <#if "UPS" == (shipmentRouteSegment.carrierPartyId)!>
                            <a href="javascript:document.upsEmailReturnLabel${shipment_index}.submit();" class="button tiny">${uiLabelMap.ProductEmailReturnShippingLabelUPS}</a>
                          </#if>
                          <form name="upsEmailReturnLabel${shipment_index}" method="post" action="<@ofbizUrl>upsEmailReturnLabelOrder</@ofbizUrl>">
                            <input type="hidden" name="orderId" value="${orderId}"/>
                            <input type="hidden" name="shipmentId" value="${shipment.shipmentId}"/>
                            <input type="hidden" name="shipmentRouteSegmentId" value="${shipmentRouteSegment.shipmentRouteSegmentId}" />
                          </form>
                        </#if>
                      </#if>
                    </div>
                </#list>
            </td>
          </tr>
       </#if>

       <#-- shipment actions -->
       <#if security.hasEntityPermission("ORDERMGR", "_UPDATE", session) && ((orderHeader.statusId == "ORDER_CREATED") || (orderHeader.statusId == "ORDER_APPROVED") || (orderHeader.statusId == "ORDER_SENT"))>


         <#-- Manual shipment options -->

         <tr>
            <td colspan="3" valign="top" width="100%" align="center">
             <#if orderHeader.orderTypeId == "SALES_ORDER">
               <#if !shipGroup.supplierPartyId?has_content>
                 <#if orderHeader.statusId == "ORDER_APPROVED">
                 <a href="/facility/control/PackOrder?facilityId=${storeFacilityId!}&amp;orderId=${orderId}&amp;shipGroupSeqId=${shipGroup.shipGroupSeqId}${StringUtil.wrapString(externalKeyParam)}" class="button tiny">${uiLabelMap.OrderPackShipmentForShipGroup}</a>
                 <br />
                 </#if>
                 <a href="javascript:document.createShipment_${shipGroup.shipGroupSeqId}.submit()" class="button tiny">${uiLabelMap.OrderNewShipmentForShipGroup}</a>
                 <form name="createShipment_${shipGroup.shipGroupSeqId}" method="post" action="/facility/control/createShipment">
                   <input type="hidden" name="primaryOrderId" value="${orderId}"/>
                   <input type="hidden" name="primaryShipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                   <input type="hidden" name="statusId" value="SHIPMENT_INPUT" />
                   <input type="hidden" name="facilityId" value="${storeFacilityId!}" />
                   <input type="hidden" name="estimatedShipDate" value="${shipGroup.shipByDate!}"/>
                 </form>
               </#if>
             <#else>
               <#assign facilities = facilitiesForShipGroup.get(shipGroup.shipGroupSeqId)>
               <#if facilities?has_content>
                   <div>
                    <form name="createShipment2_${shipGroup.shipGroupSeqId}" method="post" action="/facility/control/createShipment">
                       <input type="hidden" name="primaryOrderId" value="${orderId}"/>
                       <input type="hidden" name="primaryShipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                       <input type="hidden" name="shipmentTypeId" value="PURCHASE_SHIPMENT"/>
                       <input type="hidden" name="statusId" value="PURCH_SHIP_CREATED"/>
                       <input type="hidden" name="externalLoginKey" value="${externalLoginKey}"/>
                       <input type="hidden" name="estimatedShipDate" value="${shipGroup.estimatedShipDate!}"/>
                       <input type="hidden" name="estimatedArrivalDate" value="${shipGroup.estimatedDeliveryDate!}"/>
                       <select name="destinationFacilityId">
                         <#list facilities as facility>
                           <option value="${facility.facilityId}">${facility.facilityName}</option>
                         </#list>
                       </select>
                       <input type="submit" class="smallSubmit" value="${uiLabelMap.OrderNewShipmentForShipGroup} [${shipGroup.shipGroupSeqId}]"/>
                    </form>
                    </div>
               <#else>
                   <a href="javascript:document.quickDropShipOrder_${shipGroup_index}.submit();" class="button tiny">${uiLabelMap.ProductShipmentQuickComplete}</a>
                   <a href="javascript:document.createShipment3_${shipGroup.shipGroupSeqId}.submit();" class="button tiny">${uiLabelMap.OrderNewDropShipmentForShipGroup} [${shipGroup.shipGroupSeqId}]</a>
                   <form name="quickDropShipOrder_${shipGroup_index}" method="post" action="<@ofbizUrl>quickDropShipOrder</@ofbizUrl>">
                        <input type="hidden" name="orderId" value="${orderId}"/>
                        <input type="hidden" name="shipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                        <input type="hidden" name="externalLoginKey" value="${externalLoginKey}" />
                    </form>
                    <form name="createShipment3_${shipGroup.shipGroupSeqId}" method="post" action="/facility/control/createShipment">
                        <input type="hidden" name="primaryOrderId" value="${orderId}"/>
                        <input type="hidden" name="primaryShipGroupSeqId" value="${shipGroup.shipGroupSeqId}"/>
                        <input type="hidden" name="shipmentTypeId" value="DROP_SHIPMENT" />
                        <input type="hidden" name="statusId" value="PURCH_SHIP_CREATED" />
                        <input type="hidden" name="externalLoginKey" value="${externalLoginKey}" />
                    </form>
               </#if>
             </#if>
            </td>
         </tr>

       </#if>

      </table>
    </@section>
</#list>
</#if>
</#if>
