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