var controlAddIn = document.getElementById('controlAddIn');
//controlAddIn.innerHTML= "<a download='somedata.csv' href='#' onclick='return ExcellentExport.csv(this, 'datatable');'>Export to CSV<//a><br/>";
//controlAddIn.innerHTML = "<iframe src='https://app.powerbi.com/reportEmbed?reportId=3191edb5-7527-452b-a188-e8b15e8f12a3&amp;config=eyJjbHVzdGVyVXJsIjoiaHR0cHM6Ly9XQUJJLVVTLU5PUlRILUNFTlRSQUwtQi1yZWRpcmVjdC5hbmFseXNpcy53aW5kb3dzLm5ldCIsImVtYmVkRmVhdHVyZXMiOnsibW9kZXJuRW1iZWQiOmZhbHNlfX0%3d&amp;filterPaneEnabled=false&amp;navContentPaneEnabled=false' width='100%' height='320' frameborder='0'></iframe>";

parent.document.getElementsByClassName('ms-nav-band')[0].style.display='none';
setTimeout(function () {
run();
}, 5000);




function run() {
//  alert(parent.document.querySelectorAll("[title='WebReportViewer']")[1].id);
    var iframe = parent.document.querySelectorAll("[title='WebReportViewer']")[1];
    iframe.style.minHeight='700px';
    iframe.style.height='700px';
    //lert(iframe.id);
    if (iframe != null) {
  //      clearInterval(interval);
 //   }
   // else {
        var elem = iframe.contentWindow.document.querySelector("[seamless='seamless']");
    //    alert(elem.getAttribute('width'));
        elem.setAttribute("width", "100%");
        elem.setAttribute("height","1080px !important");
    //    sleep(15000);



    var url = elem.src;
var getData = function (data) {
    if (data && data.query && data.query.results && data.query.results.resources && data.query.results.resources.content && data.query.results.resources.status == 200) loadHTML(data.query.results.resources.content);
    else if (data && data.error && data.error.description) loadHTML(data.error.description);
    else loadHTML('Error: Cannot load ' + url);
};
var loadURL = function (src) {
    url = src;
    var script = document.createElement('script');
    script.src = 'https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20data.headers%20where%20url%3D%22' + encodeURIComponent(url) + '%22&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=getData';
    document.body.appendChild(script);
};
var loadHTML = function (html) {
    elem.src = 'about:blank';
    elem.contentWindow.document.open();
    elem.contentWindow.document.write(html.replace(/<head>/i, '<head><base href="' + url + '"><scr' + 'ipt>document.addEventListener("click", function(e) { if(e.target && e.target.nodeName == "A") { e.preventDefault(); parent.loadURL(e.target.href); } });</scr' + 'ipt>'));
    elem.contentWindow.document.close();
}
loadURL(elem.src);
        var innerDiv=elem.contentWindow.document.getElementsByClassName('innerContainer')[0];
       // alert(innerDiv);
        //iframe.removeAttribute('src');

    }
}

document.onload=function (){
    alert("call on load");
    run();
}
const interval = setInterval(run, 10000);