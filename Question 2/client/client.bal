import ballerina/grpc;
import ballerina/io;
import ballerina/log;

type User record {
    string user_id;
    string user_name;
    string user_password;
    string user_type;
};
User[] users = [
    { user_id: "1", user_name: "Reben", user_password: "dsa24", user_type: "admin" },
    { user_id: "2", user_name: "Fillemon", user_password: "passcode", user_type: "customer" },
    { user_id: "3", user_name: "Matti", user_password: "password789", user_type: "customer" },
    { user_id: "4", user_name: "Steven", user_password: "adminpass", user_type: "admin" }
    { user_id: "5", user_name: "Jafet", user_password: "sabufa77", user_type: "customer" }
    { user_id: "6", user_name: "Paules", user_password: "paul33", user_type: "customer" }
];


// Define the gRPC client
grpc:Client shoppingSystemClient = check new ("localhost:9090");

public function main() returns error? {
    User? loggedInUser = authenticateUser();
    
    if loggedInUser is () {
        io:println("Invalid credentials. Exiting...");
        return;
    }

    // Show the user's role
    io:println("Welcome ", loggedInUser.user_name, "! You are logged in as a ", loggedInUser.user_type, ".");
       
        io:println("Select an operation:");
        io:println("1. List Available Products");
        io:println("2. Search Product");
        io:println("3. Add to Cart");
        io:println("4. Place Order");
       
       
       if loggedInUser.user_type == "admin" {
        io:println("5. Add Product (Admin Only)");
        io:println("6. Update Product (Admin Only)");
        io:println("7. Remove Product (Admin Only)");
        io:println("8. List Orders (Admin Only)");
        }

        io:println("9. Exit");
    
        string option = io:readln("Enter your choice (1-6):");

        match option {
        "1" => {check listAvailableProducts();}
        "2" => {check searchProduct();}
        "3" => {check addToCart();}
        "4" => {check placeOrder();}
        //Admin  options
        "5" => {
            if loggedInUser.user_type == "admin" {
                check addProduct();
            } else {
                io:println("Unauthorized. Only admins can add products.");
            }
        }
        "6" => {
            if loggedInUser.user_type == "admin" {
                check updateProduct();
            } else {
                io:println("Unauthorized. Only admins can update products.");
            }
        }
        "7" => {
            if loggedInUser.user_type == "admin" {
                check removeProduct();
            } else {
                io:println("Unauthorized. Only admins can remove products.");
            }
        }
        "8" => {
            if loggedInUser.user_type == "admin" {
                check listOrders();
            } else {
                io:println("Unauthorized. Only admins can list orders.");
            }
        }
        "9" => {
            io:println("Exiting...");
            }
        _ => {
            io:println("Invalid choice. Please try again.");
        }
    }
}

//Authentication function
function authenticateUser() returns User? {
    io:println("Enter username:");
    string username = check <string> io:readln();

    io:println("Enter password:");
    string password = check <string> io:readln();

    // Check credentials
    foreach User user in users {
        if user.user_name == username && user.user_password == password {
            return user;
        }
    }

    return ();
}

// Function to add a product
function addProduct() returns error? {
    io:println("Enter product name:");
    string name = check <string> io:readln();

    io:println("Enter product description:");
    string description = check <string> io:readln();

    io:println("Enter product price:");
    string price = check <string> io:readln();

    io:println("Enter stock quantity:");
    string quantity = check <string> io:readln();

    io:println("Enter product SKU:");
    string sku = check <string> io:readln();

    io:println("Enter product status (available/out_of_stock):");
    string status = check <string> io:readln();

    Product product = { name: name, description: description, price: price, stock_quantity: quantity, sku: sku, status: status };
    AddProductRequest addProductRequest = { product: product };

   Responds response = check shoppingSystemClient->addProduct(addProductRequest);
    io:println("Product added with code: " + response.SKU);
}

// Function to list available products
function listAvailableProducts() returns error? {
    Responds response = check shoppingSystemClient->listAvailableProducts({});
    foreach Product product in response.products {
        io:println("Product: ", product.name, ", Price: ", product.price, ", SKU: ", product.sku);
    }
}

// Function to search for a product
function searchProduct() returns error? {
    io:println("Enter SKU to search:");
    string sku = check <string> io:readln();

    SearchProductRequest searchProductRequest = { sku: sku };
    Responds response = check shoppingSystemClient->searchProduct(searchProductRequest);

    if (response.product.sku == "") {
        io:println("Product not available");
    } else {
        io:println("Product found: ", response.product.name, ", Price: ", response.product.price ", SKU: ", product.sku);
    }
}

// Function to add to cart
function addToCart() returns error? {
    io:println("Enter user ID:");
    string userId = check <string> io:readln();

    io:println("Enter SKU of the product:");
    string sku = check <string> io:readln();

    AddToCartRequest addToCartRequest = { user_id: userId, sku: sku };
    Responds response = check shoppingSystemClient->addToCart(addToCartRequest);
    io:println(response.status);
}

// Function to place an order
function placeOrder() returns error? {
    io:println("Enter user ID:");
    string userId = check <string> io:readln();

    PlaceOrderRequest placeOrderRequest = { user_id: userId };
    Responds response = check shoppingSystemClient->placeOrder(placeOrderRequest);
    io:println(response.status);
}

// Function stubs for the other methods (if needed)
function updateProduct() returns error? {
  io:println("Enter the SKU of the product to update:");
    string sku = check <string> io:readln();

    io:println("Enter updated product name:");
    string name = check <string> io:readln();

    io:println("Enter updated product description:");
    string description = check <string> io:readln();

    io:println("Enter updated product price:");
    float price = check <float> io:readln();

    io:println("Enter updated stock quantity:");
    int quantity = check <int> io:readln();

    io:println("Enter updated product status (available/out_of_stock):");
    string status = check <string> io:readln();

    Product updatedProduct = { name: name, description: description, price: price, stock_quantity: quantity, sku: sku, status: status };
    UpdateProductRequest updateProductRequest = { product: updatedProduct };

    Responds response = check shoppingSystemClient->updateProduct(updateProductRequest);
    io:println("Product updated: " + response.status);
}


function removeProduct() returns error? {
     io:println("Enter the SKU of the product to remove:");
    string sku = check <string> io:readln();

    RemoveProductRequest removeProductRequest = { sku: sku };
    Responds response = check shoppingSystemClient->removeProduct(removeProductRequest);

    io:println("Product removed. Updated product list:");
    foreach Product product in response.products {
        io:println("Product: ", product.name, ", Price: ", product.price, ", SKU: ", product.sku);
    }
}

function listOrders() returns error? {
     Responds response = check shoppingSystemClient->listOrders({});
    foreach Order order in response.orders {
        io:println("Order ID: ", order.order_id, ", User ID: ", order.user_id, ", Total: ", order.total_price);
    }
}

function createUsers() returns error? {
    io:println("How many users to create?");
    int count = check <int> io:readln();

    grpc:ClientConnector<CreateUserRequest> clientStream = check shoppingSystemClient->createUsers();
    foreach int i in 1...count {
        io:println("Enter user type (admin/customer) for user ", i, ":");
        string user_type = check <string> io:readln();

        io:println("Enter user name:");
        string user_name = check <string> io:readln();

        int user_id = <string> random:createIntInRange(10, 30); 

        CreateUserRequest newUser = { user_id: user_id, user_type: userType, user_name: user_name };
        check clientStream->send(newUser);
    }
    check clientStream->complete();
    io:println("Users created successfully.");
}
