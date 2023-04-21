$(document).ready(function () {
  var _last_id;
    GetAllData();
    
});
function GetAllData() {
  var _url = "./GetUsers";
  $.ajax({
    type: 'GET',
      url: _url,
    headers: {
      "Content-Type": "application/json"
    },
    success: function (data) {
      //_last_id=data.length+1;
      var tbl = $("#tblProfile tbody");
      $.each(data, function (index, item) {
          var row = "<tr><td>" + (index + 1) + "</td><td>" + item.UserId + "</td><td>";
          row += "<span class='btn btn-light btn-icon-split btn-sm'><span class='icon text-gray-600'>" + item.UserName + "</span>";
          row += "<strong class='text'><button id='" + item.Id + "_btn' type='button' class='btn btn-success btn-sm'><i class='fas fa-eye'></i></button></strong></span></td><td>" + item.Email + "</td><td>" + item.Mobile + "</td>";
          row += "<td>" + item.City + "</td><td>" + item.WalletBalance + "</td></tr>";
          tbl.append(row);
          $('#'+item.Id+'_btn').click(function () {
              //alert(item.UserId);
              //$('#lblmsg').text(item.UserName);
              var _passwordurl = "./GetPassword?_id=" + item.Id
              $.ajax({
                  type: 'GET',
                  url: _passwordurl,
                  headers: {
                      "Content-Type": "application/json"
                  },
                  success: function (data) {
                      //_last_id=data.length+1;
                      $('#spnUser').text(item.UserName);
                      $('#lblmsg').text(data.Password);
                      $('#PasswordModal').modal('show');
                  },
                  error: function (eror, tur) {
                      alert("error")
                  },
              });
          });
          //$('[id*=_btn]').click(function () {
          //    alert(item.Id);
          //});
          if (index == data.length - 1) {
              $('#tblProfile').DataTable();
              
          }
      });
    },
    error: function (eror, tur) {
      alert("error")
    },
  })
}