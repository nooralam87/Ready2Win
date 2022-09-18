using EmailSend;
using System.Net.Mail;
using Newtonsoft.Json;
using ReadyToWin.Complaince.Entities.QutationRepositry;

// See https://aka.ms/new-console-template for more information
Console.WriteLine("Hello, World!");

var client = new HttpClient();
var request = new HttpRequestMessage
{
    Method = HttpMethod.Get,
    RequestUri = new Uri("https://api.bigcommerce.com/stores/v1jfzk44hb/v3/catalog/products/1845"),
    Headers =
    {
        { "Accept", "application/json" },
        { "X-Auth-Token", "5piuvue6hajkrztj17s04yusux8xffm" },
    },
};
using (var response = await client.SendAsync(request))
{
    var d = response.EnsureSuccessStatusCode();
    var str = await response.Content.ReadAsStringAsync();
    // single 
    //Customers myDeserializedClass = JsonConvert.DeserializeObject<Customers>(str)
    Products myDeserializedClass = JsonConvert.DeserializeObject<Products>(str);
    // or as a list
    //List<Customers> foos = JsonConvert.DeserializeObject<List<Customers>>(str);
    Console.WriteLine(myDeserializedClass);
}

//EmailSetup _email = new EmailSetup();
//_email.Send();
Console.WriteLine("Done");
