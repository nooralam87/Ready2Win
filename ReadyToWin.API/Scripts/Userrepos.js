$(document).ready(function () {
  var _last_id;
  GetAllData();
});
function GetAllData() {
  $.ajax({
    type: 'GET',
    url: ' http://www.ready2Enjoy.somee.com/api/user/GetAllUsers',
    headers: {
      "Content-Type": "application/json",
      "token": "Ydjca2I4rh+WzDvZbuHjRDIXRwiBjyvYNNdUtrOo99QD26IrsLK1MgX7nnJRsQS5"

    },
    success: function (data) {
      //_last_id=data.length+1;
      var tbl = $("#tblProfile tbody");
      $.each(data.data, function (index, item) {
        var row = "<tr><td>" + (index + 1) + "</td><td>" + item.userId + "</td><td>";
        row += item.userName + "</td><td>" + item.email + "</td><td>" + item.mobile + "</td>";
        row += "<td>" + (item.roles == '2' ? 'Player' : 'Admin')+"</td><td>" + item.city + "</td></tr>";
        tbl.append(row);
      });
    },
    error: function (eror, tur) {
      alert("error")
    },
  })
}