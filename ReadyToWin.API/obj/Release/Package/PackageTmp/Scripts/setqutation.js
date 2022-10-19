var v;
var _e;
var _d;
$(document).ready(function () {
    v = getUrls();
    GetProductInfobyID(v.split('&')[0]);
    $('#btncancel').on('click', function () {
        ResetForm();
    });
    $('#btnsave').on('click', function () {
        if (validate()) {
            SaveData();
        }
    });
});
function ResetForm() {
    $('#txtprice,#txtDiscription,#txtstock,#txtlowstock').val('');
}
function GetProductInfobyID(_id) {
    _e=$('#nl_email').val();
    $.ajax({
        type: 'GET',
        url: 'https://www.ready2enjoy.somee.com/api/CreateQutation/GetProductsDetails/' + _id,
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        success: function (data) {
            debugger
            if (data.code == 200) {
                _d = data.data;
                $('#txtproductName').val(_d.data.name);
                $('#txtprice').val(_d.data.price);
                $('#txtemailID').val(_e);
            }
        },
        error: function (eror, tur) {
            debugger
            alert("error")
        },
    });
}

function getUrls() {
    var hashes;
    hashes = window.location.href.slice(window.location.href.indexOf('/') + 2).split('/');
    hashes = hashes[hashes.length - 1];
    hashes = hashes.slice(hashes.indexOf('=') + 1);
    return hashes;
}
function validate() {
    if ($('#txtprice').val() == "" || $('#txtprice').val() ==undefined){
        alert('Please Enter default price* (excluding tax) !');
        return false;
    } else if ($('#txtDiscription').val() == "" || $('#txtDiscription').val() == undefined) {
        alert('Please Enter Description !');
        return false;
    }
    return true;
}
function SaveData() {

    var data = JSON.stringify({
        "productID": _d.data.id,
        //"customerEmailID": _d.customerInfo.customerEmailID,
        "customerID": v.split('&')[1],
        "description": $('#txtDiscription').val(),
        "Price": $('#txtprice').val(),
        "stock": $('#txtstock').val() == "" ? 0 : $('#txtstock').val(),
        //"lowStock": $('#txtlowstock').val() == "" ? 0 : $('#txtlowstock').val(),
        "CreatedBy": _e
    });

    $.ajax({
        type: 'POST',
        url: 'https://www.ready2enjoy.somee.com/api/Vendor/VendorReply',
        data: data,
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        success: function (data) {
            debugger
            if (data.code == 200) {
                $('#PagesStatus').html('<div class="alert alert-success"><p>The quote has been sent to customer successfully.</p>');
            } else if (data.code == 204 || data.code == 201) {
                $('#PagesStatus').html('<div class="alert alert-danger"><p>Oops Error Ocurv -- ' + data.message +'--!</p>');
            }
            ResetForm();
        },
        error: function (eror, tur) {
            debugger
            alert("error")
        },
    });
}