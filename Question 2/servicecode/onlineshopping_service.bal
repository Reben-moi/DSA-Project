import ballerina/grpc;

  // Create a gRPC listener on port 9090. This will listen for incoming gRPC requests.
listener grpc:Listener ep = new (9090);

 // Define the record to represent a product entry with an SKU (Stock Keeping Unit) as the unique identifier.
type ProductEntry record {|
    readonly string sku; 
    Product product;    
|};

 // Define the record to represent a cart entry with a user ID as the unique identifier.
type CartEntry record {|
    readonly string user_id; 
    Cart cart;               
|};

 // Define the record to represent a user entry with an ID as the unique identifier.
type UserEntry record {|
    readonly string id; 
    User user;          
|};

 // Bellow we create tables to store product, cart, and user entries, with their respective unique keys.
 // Each table is essentially an in-memory database for our online shopping system.
table<ProductEntry> key(sku) products_table = table [];  
table<CartEntry> key(user_id) carts_table = table [];    
table<UserEntry> key(id) users_table = table [];        

@grpc:Descriptor {value: ONLINE_SHOPPING_DESC}
 // Define the gRPC service named "onlineShopping" that listens for gRPC calls.
service "onlineShopping" on ep {

     // This is the gRPC method to add a new product to the products_table.
    remote function addProduct(Product product) returns ProductResponse|error {  
     products_table.add({sku: product.sku, product: product});
        return {message: "Product added successfully", product: product};
    }

     //.. This is the gRPC method to update an existing product in the products_table.
    remote function updateProduct(Product product) returns ProductResponse|error {
        products_table.put({sku: product.sku, product: product});
        return {message: "Product updated successfully", product: product};
    }

     //.. gRPC method to remove a product from the products_table by its SKU.
    remote function removeProduct(string sku) returns ProductResponse|error {
        ProductEntry? entry = products_table.remove(sku);
        if entry is ProductEntry {
            return {message: "Product removed successfully", product: entry.product};
        }
        return error("Product not found");
    }

     //.. This is the gRPC method to search for a product in the products_table by its SKU.
    remote function searchProduct(string sku) returns ProductResponse|error {
        ProductEntry? entry = products_table[sku];
        if entry is ProductEntry {
            return {message: "Product found successfully", product: entry.product};
        }
        return error("Product not found");
    }

    //.. gRPC method to add a product to a user's cart.
    remote function addToCart(Cart cart) returns CartResponse|error {
        carts_table.add({user_id: cart.user_id, cart: cart});
        return {user_id: cart.user_id};
    }

    //.. This is the gRPC method to place an order based on the items in the user's cart.
    remote function placeOrder(placeOrderRequest request) returns OrderResponse|error {
        return {user_id: request.user_id};
    }

    //.. This is the gRPC method to create multiple users from a stream of User objects.
    // This method handles a stream of incoming user data and processes it.
    remote function createUsers(stream<User, grpc:Error?> clientStream) returns UserCreationResponse|error {
        User[] users = [];
        check clientStream.forEach(function(User user) {
            users_table.add({id: user.id, user: user});  
            users.push(user); 
        });
        return {users: users};
    }

    //.. This is the gRPC method to list all available products (products that are in stock).
    remote function listAvailableProducts() returns stream<Product, error?>|error {
        stream<Product, error?> productStream = stream from var entry in products_table.toArray()
                                                where entry.product.status == "Available"
                                                select entry.product;
        // Return the stream of available products.
        return productStream;
    }
}
