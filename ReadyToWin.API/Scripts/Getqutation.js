var user_id = "";
var prod_id = "";
var prod_name = "";
$(document).ready(function () {

    GetUserInfobyID();
    user_id = getUrlVars()["edit"];
    prod_id = getUrlVars()["prod"];
    prod_name = getUrlVars()["name"];
    $('#txtproductName').val(prod_name);
    //$('#txtemailID').val(user_id);
    $('#btncancel').on('click', function () {
        $('#txtprice,#txtDiscription,#txtstock,#txtlowstock').empty();
    });
    $('#btnsave').on('click', function () {
        if (validate()) {
            SaveData();
        }
    });
});
function GetUserInfobyID(_id) {
    $.ajax({
        type: 'GET',
        url: 'https://www.ready2enjoy.somee.com/api/CreateQutation/GetCustomerDetails/106',
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        success: function (data) {
            debugger
	if(data.code==200){
            $('#txtemailID').val(data.data.email);
	}
        },
        error: function (eror, tur) {
            debugger
            alert("error")
        },
    });
}

function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
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
        "productID": prod_id,
        "customerEmailID": $('#txtemailID').val(),
        "customerID": user_id,
        "defaultPrice": $('#txtprice').val(),
        "stock": $('#txtstock').val() == "" ? 0 : $('#txtstock').val(),
        "lowStock": $('#txtlowstock').val() == "" ? 0 : $('#txtlowstock').val(),
        "userName": $('#txtemailID').val()
    });

    $.ajax({
        type: 'POST',
        url: 'https://www.ready2enjoy.somee.com/api/CreateQutation/AddQutation',
        data: data,
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
        },
        success: function (data) {
            debugger
            if (data.code == 200) {
                alert(data.message);
            } else if (data.code == 204) {
                alert(data.message);
            }
            location.reload();
        },
        error: function (eror, tur) {
            debugger
            alert("error")
        },
    });
}