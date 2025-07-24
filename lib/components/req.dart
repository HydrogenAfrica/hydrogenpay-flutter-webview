import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hydrogenpay_flutter_webview/components/payload.dart';
import 'package:hydrogenpay_flutter_webview/components/state.dart';

String paymentMethods = "card";

///Creates an HTML string with information from that parsed Payload model
String initRequest(
    PayloadModel model, String reportLink, String x, WebViewState state) {
  return """
<!DOCTYPE html>
  <html>
  <head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hydrogen Pay</title>
  </head>
  <body>
  <script module>
  let paymentResponseData;

async function handlePgData(paymentData, token, onClose, onSuccess) {
  try {
    paymentResponseData = await handleInitiateApiData(paymentData, token);
  } catch (error) {
    console.error("Error initiating payment:", error);
    return "Error in initiating payment";
  }

  if (!paymentResponseData) {
    return "Error in initiating payment";
  }
  createModal(paymentResponseData, onClose);
  return paymentResponseData.transactionRef;
}

function replaceHost(originalUrl, newHost) {
  const url = new URL(originalUrl);
  
  // Replace the hostname (host can include port; hostname is just domain)
  url.hostname = newHost;

  return url.toString();
}

function createModal(paymentResponseData, onClose) {
  const modalContainer = document.createElement("div");
  modalContainer.id = "hydrogenPay_myModal";
  modalContainer.className = "modal";
  modalContainer.style = `
    display: none; 
    position: fixed; 
    z-index: 1; 
    padding-top: 1%;
    left: 0;
    top: 0;
    min-width: 100%; 
    height: 100%; 
    overflow: auto; 
    background-color: rgba(0,0,0,0.4);
  `;

  const myModal = document.createElement("div");
  myModal.id = "hydrogenPay_modal";
  myModal.className = "modal-content";
  myModal.style = `
    background-color: transparent;
    text-align: center;
    align-items: center;
    margin: auto;
    padding: 10px;
    border-radius: 20px;
    max-width: 460px;
    height: 662px;
  `;
  const newHost = "payment-v1.hydrogenpay.com";
  const closeIcon = document.createElement("span");
  closeIcon.className = "close";
  closeIcon.innerHTML = "&times;";
  closeIcon.style = `
    color: #000;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
  `;

  closeIcon.addEventListener("click", () =>
    closeModal(paymentResponseData, onClose)
  );

  myModal.appendChild(closeIcon);
  modalContainer.appendChild(myModal);
  document.body.appendChild(modalContainer);

  modalContainer.style.display = "block";
  

  if(${model.legacy}){
  const newUrl = replaceHost(paymentResponseData.url, newHost);
  handleCreateIframe(newUrl);
  } else {
    handleCreateIframe(paymentResponseData.url);
  }
  
}

async function closeModal(paymentResponseData, onClose) {
  const modalContainer = document.getElementById("hydrogenPay_myModal");
  if (modalContainer) {
    modalContainer.remove();
    onClose && onClose(paymentResponseData.transactionRef);
  }
}

async function handleInitiateApiData(paymentData, token) {
  let response = await fetch(
    "https://api.hydrogenpay.com/bepay/api/v1/Merchant/initiate-payment",
    //"https://qa-api.hydrogenpay.com/bepayment/api/v1/Merchant/initiate-payment",

    {
      method: "POST",
      body: JSON.stringify(paymentData),
      headers: {
        "Content-type": "application/json; charset=UTF-8",
        Authorization: token,
      },
    }
  );
  const data = await response.json();
  return await data.data;
}

async function handlePaymentStatus(transactionRef, token) {
  let response = await fetch(
    "https://api.hydrogenpay.com/bepay/api/v1/Merchant/confirm-payment",
     //"https://qa-api.hydrogenpay.com/bepayment/api/v1/Merchant/confirm-payment",
    {
      method: "POST",
      body: JSON.stringify({ transactionRef, isSdk: true }),
      headers: {
        "Content-type": "application/json; charset=UTF-8",
        Authorization: token,
      },
    }
  );
  const data = await response.json();
  return await data.data;
}

function handleCreateIframe(src) {
  var iframe = document.createElement("iframe");
  iframe.className = "pgIframe";
  iframe.style.cssText = `
  width: 100%;
  height: 100%;
  border: none;
  overflow: hidden;
  @media (min-width: 621px) and (max-width: 820px) {
    width: 80%;
  }
  @media (min-width: 300px) and (max-width: 620px) {
    width: 1000%;
    height: 1000%;
  }
`;
  iframe.style.overflow = "hidden";
  iframe.style.border = "none";
  iframe.src = src;
  iframe.allow = "clipboard-read; clipboard-write";
  document.getElementById("hydrogenPay_modal").appendChild(iframe);
}

function applyModalStyle(widthPercentage) {
  const baseStyle =
    "background-color: #fefefe; text-align: center; align-items: center; margin: auto; padding: 10px; border-radius: 20px; height: 80%;";

}
  </script>
  <script>
    let paymentResponse;
    let paymentObject = {
      "amount": "${model.amount}",
      "email": "${model.email}",
      "currency": "${model.currency}",
      "description": "${model.description}",
      "meta": "${model.meta}",
      "isAPI": false,
      "isRecurring":${model.isRecurring},
      "frequency":${model.frequency},
      "CustomerName":"${model.customerName}",
      "transactionRef":${model.transactionRef?.isNotEmpty == true ? '"${model.transactionRef}"' : 'null'},
      "metaData": ${model.metaData != null ? jsonEncode(model.metaData) : 'null'},
    }

    function onClose(e) {
      var response = {event:'close', e};
      window.flutter_inappwebview.callHandler("close", JSON.stringify(response))
    }

    function onSuccess(e) {
      var response = {event:'success', e};
      window.flutter_inappwebview.callHandler(JSON.stringify(response))
    }

    function callback(response) {
       window.flutter_inappwebview.callHandler('success', JSON.stringify(response));
    }

    async function openDialogModal(token) {
      paymentResponse =  handlePgData(paymentObject, token, onClose);
      paymentResponse = await paymentResponse
      callback(paymentResponse)
    }

    openDialogModal("${model.apiKey}")


    let checkStatus = setInterval(async function() {
      const checkPaymentStatus = await handlePaymentStatus(paymentResponse, "${model.apiKey}");
        if(checkPaymentStatus.status === "Paid"){
            onSuccess(checkPaymentStatus)
            callback(checkPaymentStatus)
            clearInterval(checkStatus)
         }
      }, 2000)

  </script>
  </body>
  </html>
   """;
}

///Generates A Uri from a raw HtML string
Uri createUri(PayloadModel payload, WebViewState webViewState) {
  return Uri.dataFromString(initRequest(payload, "==", '', webViewState),
      encoding: Encoding.getByName('utf-8'), mimeType: 'text/html');
}

///Creates a simple snackbr
void displaySnack(BuildContext context,
    {String? text,
    Color? color,
    Function()? onPressed,
    Color textColor = Colors.white}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 40,
    content: Text(
      text!,
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.yellow,
    duration: Duration(seconds: 2),
  ));
}
