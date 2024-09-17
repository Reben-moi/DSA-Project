import ballerina/grpc;
import ballerina/io;
import ballerina/log;

// Define the gRPC client
grpc:Client shoppingClient = check new ("localhost:9090");

public function main() returns error? {
    
        io:println("Select an operation:");
        io:println("1. Add Product");
        io:println("2. List Available Products");
        io:println("3. Search Product");
        io:println("4. Add to Cart");
        io:println("5. Place Order");
        io:println("6. Exit");

        string option = io:readln("Enter your choice (1-6):");

        match option {
            "1" => check addProduct(),
            "2" => check listAvailableProducts(),
            "3" => check searchProduct(),
            "4" => check addToCart(),
            "5" => check placeOrder(),
            "6" => {
                io:println("Exiting...");
                return;
            }
            _ => io:println("Invalid choice. Please try again.")
        }
}


// Function to add a product
function addProduct() returns error? {
    io:println("Enter product name:");
    string name = check <string> io:readln();

    io:println("Enter product description:");
    string description = check <string> io:readln();

    io:println("Enter product price:");
    float price = check <float> io:readln();

    io:println("Enter stock quantity:");
    int quantity = check <int> io:readln();

    io:println("Enter product SKU:");
    string sku = check <string> io:readln();

    io:println("Enter product status (available/out_of_stock):");
    string status = check <string> io:readln();

    Product product = { name: name, description: description, price: price, stock_quantity: quantity, sku: sku, status: status };
    AddProductRequest addProductRequest = { product: product };

   Responds response = check shoppingClient->addProduct(addProductRequest);
    io:println("Product added with code: " + response.SKU);
}

// Function to list available products
function listAvailableProducts() returns error? {
    ListAvailableProductsResponse response = check shoppingClient->listAvailableProducts({});
    foreach Product product in response.products {
        io:println("Product: ", product.name, ", Price: ", product.price, ", SKU: ", product.sku);
    }
}

// Function to search for a product
function searchProduct() returns error? {
    io:println("Enter SKU to search:");
    string sku = check <string> io:readln();

    SearchProductRequest searchProductRequest = { sku: sku };
    SearchProductResponse response = check shoppingClient->searchProduct(searchProductRequest);

    if (response.product.sku == "") {
        io:println("Product not available");
    } else {
        io:println("Product found: ", response.product.name, ", Price: ", response.product.price);
    }
}

// Function to add to cart
function addToCart() returns error? {
    io:println("Enter user ID:");
    string userId = check <string> io:readln();

    io:println("Enter SKU of the product:");
    string sku = check <string> io:readln();

    AddToCartRequest addToCartRequest = { user_id: userId, sku: sku };
    AddToCartResponse response = check shoppingClient->addToCart(addToCartRequest);
    io:println(response.status);
}

// Function to place an order
function placeOrder() returns error? {
    io:println("Enter user ID:");
    string userId = check <string> io:readln();

    PlaceOrderRequest placeOrderRequest = { user_id: userId };
    PlaceOrderResponse response = check shoppingClient->placeOrder(placeOrderRequest);
    io:println(response.status);
}

// Function stubs for the other methods (if needed)
function updateProduct() returns error? {
    // Implement the function or remove it if not needed
}

function removeProduct() returns error? {
    // Implement the function or remove it if not needed
}

function listOrders() returns error? {
    // Implement the function or remove it if not needed
}

function createUsers() returns error? {
    // Implement the function or remove it if not needed
}
