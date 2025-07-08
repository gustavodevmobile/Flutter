// import { loadMercadoPago } from "@mercadopago/sdk-js";

// window.gerarTokenCartao = async function (publicKey, cardData, callback) {
//   await loadMercadoPago();
//   const mp = new window.MercadoPago(publicKey);

//   // usa a função global estática, não via `mp`
//   MercadoPago.cardToken
//     .create(cardData)
//     .then(function (response) {
//       callback({ status: 200, id: response.id });
//     })
//     .catch(function (error) {
//       console.error("Erro ao criar token:", error);
//       callback({ status: error.status || 400, message: error.message });
//     });
// };

// window.obterPaymentMethodId = function (publicKey, cardNumber, callback) {
//   const mp = new MercadoPago(publicKey);
//   mp.getPaymentMethods({ bin: cardNumber.substring(0, 6) }).then(function (
//     result
//   ) {
//     if (result.results && result.results.length > 0) {
//       callback(result.results[0].id);
//     } else {
//       callback(null);
//     }
//   });
// };
