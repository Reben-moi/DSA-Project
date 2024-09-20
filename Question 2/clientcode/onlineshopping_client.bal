import ballerina/io;
// import ballerina/grpc;

onlineShoppingClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    while true {
        printMenu();
        string choice = io:readln("Enter your choice: ");
        io:println("\n======================================");

        match choice {
            "1" => {
                check addProduct();
            }
            "2" => {
                check updateProduct();
            }
            "3" => {
                check removeProduct();
            }
            "4" => {
                check searchProduct();
            }
            "5" => {
                check addToCart();
            }
            "6" => {
                check placeOrder();
            }
            "7" => {
                check createUser();
            }
            "8" => {
                check listAvailableProducts();
            }
            "9" => {
                io:println("👋 Thank you for using our Online Shopping System. Goodbye!");
                return;
            }
            _ => {
                io:println("⚠️ Invalid choice. Please try again.");
            }
        }
        io:println("\nPress Enter to continue...");
        _ = io:readln();
    }
}

function printMenu() {
    io:println("📦 1. Add Product");
    io:println("🛠 2. Update Product");
    io:println("❌ 3. Remove Product");
    io:println("🔍 4. Search Product");
    io:println("🛒 5. Add to Cart");
    io:println("📦 6. Place Order");
    io:println("👤 7. Create User");
    io:println("📋 8. List Available Products");
    io:println("🚪 9. Exit");

}


function addProduct() returns error? {
    string name = io:readln("Enter product name: ");
    string description = io:readln("Enter product description: ");
    float price = check float:fromString(io:readln("Enter product price: "));
    string sku = io:readln("Enter product SKU: ");
    string status = io:readln("Enter product status (Available/Out of Stock): ");

    Product product = {
        name: name,
        description: description,
        price: price,
        sku: sku,
        status: status
    };

    ProductResponse response = check ep->addProduct(product);
    io:println("Product added successfully: ", response);
}

function updateProduct() returns error? {
    string sku = io:readln("Enter product SKU to update: ");
    string name = io:readln("Enter new product name: ");
    string description = io:readln("Enter new product description: ");
    float price = check float:fromString(io:readln("Enter new product price: "));
    string status = io:readln("Enter new product status (Available/Out of Stock): ");

    Product product = {
        name: name,
        description: description,
        price: price,
        sku: sku,
        status: status
    };

    ProductResponse response = check ep->updateProduct(product);
    io:println("Product updated successfully: ", response);
}

function removeProduct() returns error? {
    string sku = io:readln("Enter product SKU to remove: ");
    ProductResponse response = check ep->removeProduct(sku);
    io:println("Product removed successfully: ", response);
}

function searchProduct() returns error? {
    string sku = io:readln("Enter product SKU to search: ");
    ProductResponse response = check ep->searchProduct(sku);
    io:println("Product found: ", response);
}

function addToCart() returns error? {
    string userId = io:readln("Enter user ID: ");
    string sku = io:readln("Enter product SKU to add to cart: ");

    Cart cart = {
        user_id: userId,
        sku: sku
    };

    CartResponse response = check ep->addToCart(cart);
    io:println("Product added to cart: ", response);
}

function placeOrder() returns error? {
    string userId = io:readln("Enter user ID to place order: ");

    placeOrderRequest request = {
        user_id: userId
    };

    OrderResponse response = check ep->placeOrder(request);
    io:println("Order placed successfully: ", response);
}
function createUser() returns error? {
    string id = io:readln("Enter user ID: ");
    string name = io:readln("Enter user name: ");
    string role = io:readln("Enter user role (customer/admin): ");

    User user = {
        id: id,
        name: name,
        role: role
    };

    CreateUsersStreamingClient streamingClient = check ep->createUsers();

    check streamingClient->sendUser(user);
    check streamingClient->complete();

    UserCreationResponse? response = check streamingClient->receiveUserCreationResponse();

    if response is UserCreationResponse {
        io:println("User created successfully. Response: ", response);
    } else {
        io:println("No response received from the server.");
    }
}

function listAvailableProducts() returns error? {
    stream<Product, error?> productStream = check ep->listAvailableProducts();
    io:println("Available Products:");
    check productStream.forEach(function(Product p) {
        io:println("- ", p);
    });
}