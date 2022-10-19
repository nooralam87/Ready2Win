$(document).ready(function () {
  var _last_id;
  GetAllData();
});
function GetAllData() {
  $.ajax({
    type: 'GET',
      url: 'GetUsers',
    headers: {
      "Content-Type": "application/json"
    },
    success: function (data) {
      //_last_id=data.length+1;
      var tbl = $("#tblProfile tbody");
      $.each(data.data, function (index, item) {
        var row = "<tr><td>" + (index + 1) + "</td><td>" + item.userId + "</td><td>";
        row += item.userName + "</td><td>" + item.email + "</td><td>" + item.mobile + "</td>";
        row += "<td>" + (item.roles == '2' ? 'Player' : 'Admin')+"</td><td>" + item.city + "</td></tr>";
          tbl.append(row);
          if (index == data.data.length - 1) {
              $('#tblProfile').DataTable();
          }
      });
        $.each(data.data, function (index, item) {
            var row = "<tr><td>" + (index + 1) + "</td><td>" + item.userId + "</td><td>";
            row += item.userName + "</td><td>" + item.email + "</td><td>" + item.mobile + "</td>";
            row += "<td>" + (item.roles == '2' ? 'Player' : 'Admin') + "</td><td>" + item.city + "</td></tr>";
            tbl.append(row);
            if (index == data.data.length - 1) {
                $('#tblProfile').DataTable();
            }
        });
    },
    error: function (eror, tur) {
      alert("error")
    },
  })
}