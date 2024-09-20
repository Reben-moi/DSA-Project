import ballerina/grpc;

// Create a gRPC listener on port 9090. This will listen for incoming gRPC requests.
listener grpc:Listener ep = new (9090);

// Define a record to represent a product entry with an SKU (Stock Keeping Unit) as the unique identifier.
type ProductEntry record {|
    readonly string sku; // SKU is read-only to ensure immutability.
    Product product;     // The product itself contains details like name, price, description, etc.
|};

// Define a record to represent a cart entry with a user ID as the unique identifier.
type CartEntry record {|
    readonly string user_id; // Unique identifier for the user.
    Cart cart;               // Cart object containing items added by the user.
|};

// Define a record to represent a user entry with an ID as the unique identifier.
type UserEntry record {|
    readonly string id;  // Unique identifier for the user.
    User user;           // User object containing user details such as name, role, etc.
|};

// Create tables to store product, cart, and user entries, with their respective unique keys.
// Each table is essentially an in-memory database for our online shopping system.
table<ProductEntry> key(sku) products_table = table [];  // Table to store products, keyed by SKU.
table<CartEntry> key(user_id) carts_table = table [];    // Table to store carts, keyed by user ID.
table<UserEntry> key(id) users_table = table [];         // Table to store users, keyed by user ID.

@grpc:Descriptor {value: ONLINE_SHOPPING_DESC}
// Define the gRPC service named "onlineShopping" that listens for gRPC calls.
service "onlineShopping" on ep {

    // gRPC method to add a new product to the products_table.
    remote function addProduct(Product product) returns ProductResponse|error {
        // Add the product to the table using its SKU as the key.
        products_table.add({sku: product.sku, product: product});
        // Return a response indicating that the product was successfully added.
        return {message: "Product added successfully", product: product};
    }

    // gRPC method to update an existing product in the products_table.
    remote function updateProduct(Product product) returns ProductResponse|error {
        // Update the product entry in the table by replacing the old entry with the new one.
        products_table.put({sku: product.sku, product: product});
        // Return a response indicating the product was successfully updated.
        return {message: "Product updated successfully", product: product};
    }

    // gRPC method to remove a product from the products_table by its SKU.
    remote function removeProduct(string sku) returns ProductResponse|error {
        // Try to remove the product from the table using its SKU.
        ProductEntry? entry = products_table.remove(sku);
        // If the product was found and removed, return a success message.
        if entry is ProductEntry {
            return {message: "Product removed successfully", product: entry.product};
        }
        // If the product wasn't found, return an error.
        return error("Product not found");
    }
// gRPC method to search for a product in the products_table by its SKU.
    remote function searchProduct(string sku) returns ProductResponse|error {
        // Retrieve the product entry from the table using the SKU.
        ProductEntry? entry = products_table[sku];
        // If the product was found, return a success message along with the product details.
        if entry is ProductEntry {
            return {message: "Product found successfully", product: entry.product};
        }
        // If the product wasn't found, return an error.
        return error("Product not found");
    }

    // gRPC method to add a product to a user's cart.
    remote function addToCart(Cart cart) returns CartResponse|error {
        // Add the cart entry to the carts_table using the user's ID as the key.
        carts_table.add({user_id: cart.user_id, cart: cart});
        // Return a response containing the user ID to confirm the product was added to the cart.
        return {user_id: cart.user_id};
    }

    // gRPC method to place an order based on the items in the user's cart.
    remote function placeOrder(placeOrderRequest request) returns OrderResponse|error {
        // Order processing logic would go here (e.g., checking inventory, processing payment, etc.).
        // Return a response indicating that the order was placed successfully, with the user ID.
        return {user_id: request.user_id};
    }

    // gRPC method to create multiple users from a stream of User objects.
    // This method handles a stream of incoming user data and processes it.
    remote function createUsers(stream<User, grpc:Error?> clientStream) returns UserCreationResponse|error {
        // Initialize an empty list to hold the user objects.
        User[] users = [];
        // Iterate over each user in the stream and add them to the users_table.
        check clientStream.forEach(function(User user) {
            users_table.add({id: user.id, user: user});  // Add each user to the table.
            users.push(user);  // Add each user to the local users list.
        });
        // Return a response with the list of users created.
        return {users: users};
    }

    // gRPC method to list all available products (products that are in stock).
    // This returns a stream of Product objects that are currently available.
    remote function listAvailableProducts() returns stream<Product, error?>|error {
        // Create a stream from the products_table, filtering only products with the status "Available".
        stream<Product, error?> productStream = stream from var entry in products_table.toArray()
                                                where entry.product.status == "Available"
                                                select entry.product;
        // Return the stream of available products.
        return productStream;
    }
}
