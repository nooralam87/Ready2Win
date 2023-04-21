var ckBC = {
    show: false,
    client: false,
    storeId: '',
    checkoutId: '',
    cartAmount: 0,
    config: false,
    endpoint: 'https://bigcommerce.creditkey.com/bc/'
}
var _checkoutData=[];
var _valFlag;
var Custname;
var email;
var mobileno;
var address;
var ListItem=[];
var fullDate = new Date()
var itemDetail={
    "id": 0,
    "productID": null,
    "customerEmailID": null,
    "customerName": null,
    "shippingAddress": null,
    "mobileNo": null,
    "ipAdress": null,
    "salePrice": null,
    "extendedSalePrice": null,
    "quantity": null,
    "customerID": null,
    "isActive": true,
    "createdDate": fullDate,
        "updatedDate": fullDate,
    "createdBy": "",
    "updatedBy": "",
    "cartId": null,
    "customerType": null,
    "isSentoVendor": true,
    "brand": null,
    "url": null,
    "imageUrl": null,
    "productName": null
  }
  var alpha= [
      {
        "id": 1,
        "productID": 12,
        "customerEmailID": "abdulrub44469@gmail.com",
        "customerName": "sample string 3",
        "shippingAddress": "sample string 4",
        "mobileNo": "sample",
        "ipAdress": "sample string 6",
        "salePrice": 12,
        "extendedSalePrice": 123,
        "quantity": 7,
        "customerID": 123,
        "isActive": true,
        "createdDate": "2022-11-06T02:52:54.3754596+05:30",
        "updatedDate": "2022-11-06T02:52:54.3754596+05:30",
        "createdBy": "sample string 10",
        "updatedBy": "sample string 11",
        "cartId": "898afbbc-7dc6-4de7-b6d4-ab7c10cbcc5c",
        "customerType": "sample",
        "isSentoVendor": true,
        "brand": "sample",
        "url": "sample",
        "imageUrl": "sample",
        "productName": "sample"
      }
    ]

function formValue(){
    Custname = $("#txtname").val().trim();
    email = $("#txtemailID").val().trim();
    mobileno = $("#txtmobileno").val().trim();
    address = $("#txtAddress").val().trim();
    if(Custname !=null && email !=null && mobileno != null && address != null){
        _valFlag=1;
    }else{
        _valFlag=0;
    }

}
$("#btnsave").click(function(){
    formValue();
    if(_checkoutData.cart.lineItems.physicalItems && _valFlag==1){
        $.each(_checkoutData.cart.lineItems.physicalItems, function (index, item) {
            // itemDetail.id=item.id;
            itemDetail.productID=item.productId;
            itemDetail.customerEmailID=email;
            itemDetail.customerName=Custname;
            itemDetail.shippingAddress=address;
            itemDetail.mobileNo=mobileno;
            itemDetail.salePrice=item.salePrice;
            itemDetail.ipAdress='';
            itemDetail.extendedSalePrice=item.extendedSalePrice;
            itemDetail.quantity=item.quantity;
            itemDetail.customerID=_checkoutData.cart.customerId;
            itemDetail.isActive=true;
            itemDetail.cartId=_checkoutData.cart.id;
            if(_checkoutData.cart.customerId != null){
                itemDetail.createdBy=Custname;
                itemDetail.customerType="Existing";
            }else{
                itemDetail.createdBy="Guest";
                itemDetail.customerType="Guest";
            }
            itemDetail.isSentoVendor=true;
            itemDetail.brand=item.brand;
            itemDetail.url=item.url;
            itemDetail.imageUrl=item.imageUrl;
            itemDetail.productName=item.name;

            ListItem.push(itemDetail);
        });
         var url="https://www.ready2enjoy.somee.com/AddQutation";
         $.ajax({
            type: "POST",
            url: url,
            dataType:"json",
            // data: ListItem,
            data: JSON.stringify(ListItem),
            contentType: "application/json;charset=utf-8",
            success: function( data){
                debugger
                alert(data.message);
            },
            error: function( jqXhr, textStatus, error ){
                debugger;
                console.log( error );
            }
          });
    }

});
jQuery(function() {

    var ckSDK = document.createElement("script");
    ckSDK.type = "text/javascript";
    ckSDK.onload = function() {

        var endpoint = ckBC.endpoint + 'config?store=' + window.location.hostname;

        $.get(endpoint, function(response) {
            ckBC.storeId = response.store_id;
            ckBC.config = response.config;
            ckBC.client = new ck.Client(ckBC.config.api_public_key, ckBC.config.api_mode);

            // PDP presentation.
            var price = parseInt($('[itemprop=price]').attr('content'));
            if(ckBC.config.promote_pdp == 'true' && price >= ckBC.config.minimum_product_price) {
                setupPDP(price);
            }

            if(ckBC.config.promote_cart == 'true' && window.location.pathname.indexOf("/checkavailability") >= 0) {
                var bcSDK = document.createElement("script");
                bcSDK.type = "text/javascript";
                $("head").append(bcSDK);
                bcSDK.onload = function() {
                    setupCart();
                }
                bcSDK.src = "https://checkout-sdk.bigcommerce.com/v1/loader.js";
            }

            if(ckBC.config.enable_checkout == 'true' && window.location.pathname.indexOf("/checkout") >= 0) {
                setupCheckout();
            }
        });
    };
    $("head").append(ckSDK);
    $("head").append('<style>[classname="iframe-container"]{width:100%;}#creditkey-pdp-iframe{border:0;}</style>')
    ckSDK.src = "https://unpkg.com/@credit-key/creditkey-js@latest/umd/creditkey-js.js";
});

function setupPDP(price) {

    const charges = new ck.Charges(price, 0, 0, 0, price);

    var res = ckBC.client.get_pdp_display(charges);

    var $elem = $(res);
    $elem.css('display', 'block');

    var selector = '.productView-options';
    if(ckBC.config.custom_selector && $(ckBC.config.custom_selector).length > 0)
        selector = ckBC.config.custom_selector;

    $(selector).append($elem);

    if(ckBC.config.custom_selector_alt && $(ckBC.config.custom_selector_alt).length > 0) {
        $(ckBC.config.custom_selector_alt).append($elem.clone());
    }
}

async function setupCart() {

    const module = await checkoutKitLoader.load('checkout-sdk');
    const service = module.createCheckoutService();
    const state = await service.loadCheckout();
    const checkout = state.data.getCheckout();
    loadItems(checkout);
    const charges = new ck.Charges(checkout.grandTotal , 0, 0, 0, checkout.grandTotal);
    var res = ckBC.client.get_cart_display(
        charges, 
        ckBC.config.cart_align_desktop ? ckBC.config.cart_align_desktop : 'right', 
        ckBC.config.cart_align_mobile ? ckBC.config.cart_align_mobile : 'center', 
    );
    var $elem = $(res);
    $elem.css('display', 'block').css('float', 'right').css('margin-top', '20px');

    var selector = '.cart-actions';
    if(ckBC.config.cart_custom_selector && $(ckBC.config.cart_custom_selector).length > 0)
        selector = ckBC.config.cart_custom_selector;

    if(selector == '.cart-actions')
        $(selector).after($elem);
    else
        $(selector).append($elem);

    if(ckBC.config.cart_custom_selector_alt && $(ckBC.config.cart_custom_selector_alt).length > 0) {
        $(ckBC.config.cart_custom_selector_alt).append($elem.clone());
    }
}

async function setupCheckout() {

    var bcSDK = document.createElement("script");
    bcSDK.type = "text/javascript";
    $("head").append(bcSDK);
    bcSDK.onload = function() {
        loadCheckout();
    }
    bcSDK.src = "https://checkout-sdk.bigcommerce.com/v1/loader.js";
}

var selectors = {
    placeOrderBtn: "#checkout-payment-continue"
};

var showLoadingIndicator = function() {
    $(selectors.placeOrderBtn).addClass("is-loading")
};
var hideLoadingIndicator = function() {
    $(selectors.placeOrderBtn).removeClass("is-loading")
};
var enableFinishOrderButton = function() {
    $(selectors.placeOrderBtn).attr("disabled", false)
};
var disableFinishOrderButton = function() {
    $(selectors.placeOrderBtn).attr("disabled", true)
};

var initPayment = function(formData, cart) {
    window.location.href = ckBC.endpoint + "checkout/start?store=" + ckBC.storeId + "&checkout_id=" + ckBC.checkoutId;
}

async function loadCheckout() {
    const module = await checkoutKitLoader.load('checkout-sdk');
    const service = module.createCheckoutService();
    const state = await service.loadCheckout();
    const checkout = state.data.getCheckout();
    ckBC.checkoutId = checkout.id;
    ckBC.cartAmount = checkout.grandTotal;

    if(ckBC.cartAmount >= ckBC.config.minimum_order_amount) {
        showCK();
        bindEvents();
        initCheckout();
    }
}
async function loadItems(_checkout) {
    var tbl = $("#tblcheckavail tbody");
    _checkoutData=_checkout;
    tbl.empty();
    $.each(_checkout.cart.lineItems.physicalItems, function (index, item) {
        
        var row = '<tr class="cart-item"><td class="cart-item-block cart-item-figure"><img class="cart-item-image" src="'+item.imageUrl+'" ></td>';
        row += '<td class="cart-item-block cart-item-title"><p class="cart-item-brand">'+item.brand+'</p><h4 class="cart-item-name"><a href="'+item.url+'">'+item.name+'</a></h4></td>';
        row += '<td class="cart-item-block cart-item-info"><strong class="cart-item-value ">$'+item.salePrice+'</strong></td>';
        row += '<td class="cart-item-block cart-item-info cart-item-quantity"><input id="txtquantity" class="form-input" type="number" name="txtquantity" value="'+item.quantity+'"/></td>';
        row += '<td class="cart-item-block cart-item-info"><strong class="cart-item-value ">$'+item.extendedSalePrice+'</strong></td></tr>';
        tbl.append(row);
    }); 
}
async function completeOrder() {
    const module = await checkoutKitLoader.load('checkout-sdk');
    const service = module.createCheckoutService();
    const state = await service.loadCheckout();
    const methods = await service.loadPaymentMethods();
    const payment = { methodId: 'cod' };
    await service.initializePayment(payment);
    const result = await service.submitOrder({ payment }, { useStoreCredit: true });
    const order = result.data.getOrder();
    
    try {
        var data = {
            checkout_id: ckBC.checkoutId,
            order_id: order.orderId
        };
        $.post(ckBC.endpoint + 'checkout/' + ckBC.checkoutId + '/completed', data, function(response) {
            window.location.replace("/checkout/order-confirmation")
        });
    } catch(e) {
        window.location.replace("/checkout/order-confirmation")
    }
}

var initCheckout = function() {

    $.ajax({
        url: ckBC.endpoint + "checkout?store=" + ckBC.storeId + "&checkout_id=" + ckBC.checkoutId,
        headers: {
            Accept: "application/json",
            "Content-Type": "application/json"
        },
        type: "GET",
        dataType: "json",
        success: function(response) {
            if(response.order && response.order.ck_id) {

                if(response.order.bc_id) {
                    window.location.replace("/checkout/order-confirmation")
                    return;
                }

                var overlay = '<div style="position:fixed;top:0;left:0;width:100%;height:100%;opacity: .9;z-index:999;background: #fff;display: block;font-weight: bold;font-size: 30px;text-align: center;padding-top: 30%;">Completing Order...</div>';
                $('body').prepend(overlay);
                completeOrder();
            }
        },
        fail: function(result) {
            console.log("Fail 33")
        }
    })
}

var paymentSubmitted = false;
var bindEvents = function() {
    
    $("html").on("click", selectors.placeOrderBtn, function(e) {
        
        var id = $(".optimizedCheckout-form-checklist-checkbox:checked").attr("id");
        if(id !== "radio-cod")
            return true;

        e.preventDefault();
        e.stopPropagation();
        if (paymentSubmitted || id !== "radio-cod") {
            return true
        }
        
        disableFinishOrderButton();
        showLoadingIndicator();
        initPayment();
    });
};

var hideCK = function() {
    var hideCKt = setInterval(function() {
        $("#radio-cod").parent().hide();
        clearInterval(hideCKt);
    }, 500)
};

var changeCheckoutText = function() {
    var $elem = $("#checkout-payment-continue");
    
    // Handle Bolt mucking around with the DOM and breaking things.
    // If we try to update the text when Bolt is installed it breaks
    // things due to Bolt adding additional children to the button.
    if($('#radio-bolt').length > 0)
        return;

    if(document.getElementById("radio-cod").checked) {
        $elem.text("Continue with Credit Key")
    }
    else {
        $elem.text("Place Order")
    }
};

var showCK = function(cart) {
    
    var showCKt = setInterval(function() {
        
        if($("#radio-cod").length == 0 || $("#radio-cod").prop('ck') == 'enabled')
            return;

        $('#radio-cod').prop('ck', 'enabled');

        try {
            $("#radio-cod").parent().show()
        } catch (e) {
            $("label[for='radio-cod']").show()
        }
        var data = Array.prototype.slice.call(document.getElementsByClassName("paymentProviderHeader-name"));
        if (data.length > 0) {
            $('.form-checklist label[for="radio-cod"]').css("display", "block");
            data.forEach(function(item) {
                if (item.innerHTML.includes("Credit Key") || item.innerHTML.includes("Monthly Payments")) {
                    item.innerHTML = '<img src="https://creditkey-assets.s3-us-west-2.amazonaws.com/ck-checkout%402x.png" alt="credit key logo image" style="width:194px;" />';                       
                }
            });
        }
        
        $("#checkout-payment-continue").attr("disabled", false);
        $('body').on('click', 'input[type=radio]', function() {
            changeCheckoutText();
        });
    }, 200)
};