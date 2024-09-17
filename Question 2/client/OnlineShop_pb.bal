import ballerina/grpc;
import ballerina/protobuf;

public const string ONLINESHOP_DESC = "0A104F6E6C696E6553686F702E70726F746F120873686F7070696E671A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F1A1B676F6F676C652F70726F746F6275662F656D7074792E70726F746F22B0010A1141646450726F647563745265717565737412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512160A06737461747573180620012809520673746174757322B3010A1455706461746550726F647563745265717565737412100A03736B751801200128095203736B7512120A046E616D6518022001280952046E616D6512200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12140A0570726963651804200128015205707269636512250A0E73746F636B5F7175616E74697479180520012805520D73746F636B5175616E7469747912160A06737461747573180620012809520673746174757322280A1452656D6F766550726F647563745265717565737412100A03736B751801200128095203736B7522130A114C6973744F726465727352657175657374221E0A1C4C697374417661696C61626C6550726F64756374735265717565737422280A1453656172636850726F647563745265717565737412100A03736B751801200128095203736B75223D0A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75222C0A11506C6163654F726465725265717565737412170A07757365725F69641801200128095206757365724964225D0A11437265617465557365725265717565737412170A07757365725F69641801200128095206757365724964121B0A09757365725F747970651802200128095208757365725479706512120A046E616D6518032001280952046E616D6522A6010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512160A067374617475731806200128095206737461747573226A0A054F7264657212190A086F726465725F696418012001280952076F72646572496412170A07757365725F69641802200128095206757365724964122D0A0870726F647563747318032003280B32112E73686F7070696E672E50726F64756374520870726F647563747322240A08526573706F6E647312180A076D65737361676518012001280952076D65737361676532F0040A0E53686F7070696E6753797374656D123D0A0A41646450726F64756374121B2E73686F7070696E672E41646450726F64756374526571756573741A122E73686F7070696E672E526573706F6E647312430A0D55706461746550726F64756374121E2E73686F7070696E672E55706461746550726F64756374526571756573741A122E73686F7070696E672E526573706F6E647312430A0D52656D6F766550726F64756374121E2E73686F7070696E672E52656D6F766550726F64756374526571756573741A122E73686F7070696E672E526573706F6E6473123D0A0A4C6973744F7264657273121B2E73686F7070696E672E4C6973744F7264657273526571756573741A122E73686F7070696E672E526573706F6E647312530A154C697374417661696C61626C6550726F647563747312262E73686F7070696E672E4C697374417661696C61626C6550726F6475637473526571756573741A122E73686F7070696E672E526573706F6E647312430A0D53656172636850726F64756374121E2E73686F7070696E672E53656172636850726F64756374526571756573741A122E73686F7070696E672E526573706F6E6473123B0A09416464546F43617274121A2E73686F7070696E672E416464546F43617274526571756573741A122E73686F7070696E672E526573706F6E6473123D0A0A506C6163654F72646572121B2E73686F7070696E672E506C6163654F72646572526571756573741A122E73686F7070696E672E526573706F6E647312400A0B4372656174655573657273121B2E73686F7070696E672E43726561746555736572526571756573741A122E73686F7070696E672E526573706F6E64732801620670726F746F33";

public isolated client class ShoppingSystemClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ONLINESHOP_DESC);
    }

    isolated remote function AddProduct(AddProductRequest|ContextAddProductRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function AddProductContext(AddProductRequest|ContextAddProductRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        AddProductRequest message;
        if req is ContextAddProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(UpdateProductRequest|ContextUpdateProductRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function UpdateProductContext(UpdateProductRequest|ContextUpdateProductRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        UpdateProductRequest message;
        if req is ContextUpdateProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(RemoveProductRequest|ContextRemoveProductRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function RemoveProductContext(RemoveProductRequest|ContextRemoveProductRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        RemoveProductRequest message;
        if req is ContextRemoveProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function ListOrders(ListOrdersRequest|ContextListOrdersRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        ListOrdersRequest message;
        if req is ContextListOrdersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/ListOrders", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function ListOrdersContext(ListOrdersRequest|ContextListOrdersRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        ListOrdersRequest message;
        if req is ContextListOrdersRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/ListOrders", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(ListAvailableProductsRequest|ContextListAvailableProductsRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableProductsRequest message;
        if req is ContextListAvailableProductsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function ListAvailableProductsContext(ListAvailableProductsRequest|ContextListAvailableProductsRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableProductsRequest message;
        if req is ContextListAvailableProductsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(SearchProductRequest|ContextSearchProductRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function SearchProductContext(SearchProductRequest|ContextSearchProductRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        SearchProductRequest message;
        if req is ContextSearchProductRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(PlaceOrderRequest|ContextPlaceOrderRequest req) returns Responds|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Responds>result;
    }

    isolated remote function PlaceOrderContext(PlaceOrderRequest|ContextPlaceOrderRequest req) returns ContextResponds|grpc:Error {
        map<string|string[]> headers = {};
        PlaceOrderRequest message;
        if req is ContextPlaceOrderRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingSystem/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Responds>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("shopping.ShoppingSystem/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCreateUserRequest(CreateUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCreateUserRequest(ContextCreateUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveResponds() returns Responds|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <Responds>payload;
        }
    }

    isolated remote function receiveContextResponds() returns ContextResponds|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <Responds>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class ShoppingSystemRespondsCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendResponds(Responds response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextResponds(ContextResponds response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextCreateUserRequestStream record {|
    stream<CreateUserRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextListAvailableProductsRequest record {|
    ListAvailableProductsRequest content;
    map<string|string[]> headers;
|};

public type ContextPlaceOrderRequest record {|
    PlaceOrderRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveProductRequest record {|
    RemoveProductRequest content;
    map<string|string[]> headers;
|};

public type ContextListOrdersRequest record {|
    ListOrdersRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUserRequest record {|
    CreateUserRequest content;
    map<string|string[]> headers;
|};

public type ContextAddProductRequest record {|
    AddProductRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateProductRequest record {|
    UpdateProductRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchProductRequest record {|
    SearchProductRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextResponds record {|
    Responds content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type Order record {|
    string order_id = "";
    string user_id = "";
    Product[] products = [];
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type ListAvailableProductsRequest record {|
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type PlaceOrderRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type RemoveProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type ListOrdersRequest record {|
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    string status = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type CreateUserRequest record {|
    string user_id = "";
    string user_type = "";
    string name = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type AddProductRequest record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    string status = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type UpdateProductRequest record {|
    string sku = "";
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string status = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type SearchProductRequest record {|
    string sku = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string sku = "";
|};

@protobuf:Descriptor {value: ONLINESHOP_DESC}
public type Responds record {|
    string message = "";
|};

