echo 'wistkey=JSON.parse(document.getElementsByTagName("script")[12].text)["@id"].split("/")[5];wista=document.createElement("textarea");wista.id="tempid";wista.innerText=wistkey;document.body.appendChild(wista);wists=document.querySelector("#tempid");wists.select();document.execCommand("copy");document.getElementById("tempid").remove();wistkey=wista=wists=null;' | pbcopy

