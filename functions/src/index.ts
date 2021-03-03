import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { CieloConstructor, Cielo, TransactionCreditCardRequestModel, EnumBrands, CaptureRequestModel } from 'cielo';

admin.initializeApp();

// Start writing Firebase Functions
// https://firebase.google.com/docs/functions/typescript

const merchantId = functions.config().cielo.merchantid;
const merchantKey = functions.config().cielo.merchantkey;

const cieloParams: CieloConstructor = {
    merchantId: merchantId,
    merchantKey: merchantKey,
    sandbox: true,
    debug: true,
}

const cielo = new Cielo(cieloParams);

export const authorizeCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        };
    }

    const userId = context.auth.uid;

    const snapshot = await admin.firestore().collection("users").doc(userId).get();
    const userData = snapshot.data() || {};

    console.log("Iniciando Autorização");

    let brand: EnumBrands;
    switch(data.creditCard.brand){
        case "VISA":
            brand = EnumBrands.VISA;
            break;
        case "MASTERCARD":
            brand = EnumBrands.MASTER;
            break;
        case "AMEX":
            brand = EnumBrands.AMEX;
            break;
        case "ELO":
            brand = EnumBrands.ELO;
            break;
        case "JCB":
            brand = EnumBrands.JCB;
            break;
        case "DINERSCLUB":
            brand = EnumBrands.DINERS;
            break;
        case "DISCOVER":
            brand = EnumBrands.DISCOVERY;
            break;
        case "HIPERCARD":
            brand = EnumBrands.HIPERCARD;
            break;
        default:
            return {
                "sucess": false,
                "error":{
                    "code": -1,
                    "message": "Cartão não suportado: " + data.creditCard.brand
                }
            }
    }

    const saleData: TransactionCreditCardRequestModel = {
        merchantOrderId: data.merchantOrderId,
        customer: {
            name: userData.name,
            identity: data.cpf,
            identityType: 'CPF',
            email: userData.email,
            deliveryAddress: {
                street: userData.address.street,
                number: userData.address.number,
                complement: userData.address.complement,
                zipCode: userData.address.zipCode.replace('.', '').replace('-', ''),
                city: userData.address.city,
                state: userData.address.state,
                country: "BRA",
                district: userData.address.district,
            }
        },
        payment: {
            currency: 'BRL',
            country: 'BRA',
            amount: data.amount,
            installments: data.installments,
            softDescriptor: data.softDescriptor.substring(0,13),
            type: data.paymentType,
            capture: false,
            creditCard: {
                cardNumber: data.creditCard.cardNumber,
                holder: data.creditCard.holder,
                expirationDate: data.creditCard.expirationDate,
                securityCode: data.creditCard.securityCode,
                brand: brand
            }

        }
    }

    try {
        
        const transaction = await cielo.creditCard.transaction(saleData);

        if(transaction.payment.status === 1){
            return {
                "sucess": true,
                "paymentId": transaction.payment.paymentId,
            }
        } else {
            let message = '';
            switch(transaction.payment.returnCode){
                    case '5':
                        message = 'Não Autorizada';
                        break;
                    case '57':
                        message = 'Cartão expirado';
                        break;
                    case '78':
                        message = 'Cartão bloqueado';
                        break;
                    case '99':
                        message = 'Esgotou o tempo da transação';
                        break;
                    case '77':
                        message = 'Cartão cancelado';
                        break;
                    case '70':
                        message = 'Problemas com o Cartão de Crédito'
                        break;
                    default:
                        message = transaction.payment.returnMessage;
                        break;
            }
            return {
                "sucess": false,
                "status": transaction.payment.status,
                "error": {
                    "code": transaction.payment.returnCode,
                    "message": message
                }
            }
        }
    } catch(error){
        console.log("Error",error);
        return {
            "sucess": false,
            "error": {
                "code": error.response[0].Message,
                "message": error.response[0].Message,
            }
        }

    }

});



export const captureCreditCard = functions.https.onCall(async (data, context) => {
    if(data === null){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Dados não informados"
            }
        };
    }

    if(!context.auth){
        return {
            "success": false,
            "error": {
                "code": -1,
                "message": "Nenhum usuário logado"
            }
        };
    }
    const captureParams: CaptureRequestModel = {
        paymentId: data.payId,
    };

    try {
        const capture = await cielo.creditCard.captureSaleTransaction(captureParams);
        if(capture.status === 2){
            return {"sucess": true};
        } else {
            return {
                "success": false,
                "status": capture.status,
                "error": {
                    "code": capture.returnCode,
                    "message": capture.returnMessage,
                }
        };
        }
    }
    catch(error){
        console.log("Error",error);
        return {
            "sucess": false,
            "error": {
                "code": error.response[0].Message,
                "message": error.response[0].Message,
            }
        }

    }
});



export const getUserData = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        return {
            "data": "Nenhum usuário logado",
        };
    }

    console.log(context.auth.uid);

    const snapshot = await admin.firestore().collection("users").doc(context.auth.uid).get();

    console.log(snapshot.data());
    return {
        "data": snapshot.data()
    };
});


export const addMessage = functions.https.onCall(async (data, context) => {
    console.log(data);

    const snapshot = await admin.firestore().collection("messages").add(data);

    return { "sucess": snapshot.id };
});


export const onNewOrder = functions.firestore.document("/orders/{orderId}").onCreate((snapshot, context) => {
    const orderId = context.params.orderId;
    console.log(orderId);
});