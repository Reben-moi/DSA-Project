<<<<<<< HEAD
import ballerina/io;
=======
import ballerina/grpc;
>>>>>>> 7f6f1d99d312d75fb3ea16439a86d781a2110000

<<<<<<< HEAD
public function main() {
    io:println("Hello, World!");
}

=======
listener grpc:Listener shoppingEP = new (9090);

@grpc:ServiceDescriptor {
    descriptor: ROOT_DESCRIPTOR_SHOPPING,
    descMap: getDescriptorMapShopping()
}
service "shoppingManagement" on shoppingEP {
    private map<Product> products = {};
    private map<User> users = {};
    private map<string, Cart> carts = {}; // Mapping userID to their cart
    private map<string, Order> orders = {}; // Mapping orderID to the order

    remote function add_product(Product request) returns string|error {
        string sku = request.SKU;
        if (self.products.hasKey(sku)) {
            return error("Product with SKU ${sku} already exists");
        } else {
            self.products[sku] = request;
            return sku; // Return the SKU of the added product
        }
    }

    remote function create_users(stream<User, error?> userStream) returns Responds|error {
        foreach var user in userStream {
            string userID = user.userID;
            if (self.users.hasKey(userID)) {
                return error("User with ID ${userID} already exists");
            } else {
                self.users[userID] = user;
            }
        }
        return {message: "Users created successfully"};
    }

    remote function update_product(Product request) returns Responds|error {
        string sku = request.SKU;
        if (self.products.hasKey(sku)) {
            self.products[sku] = request;
            return {message: "Product updated successfully"};
        } else {
            return error("No product with SKU ${sku} exists");
        }
    }

    remote function remove_product(string sku) returns map<Product>|error {
        if (self.products.hasKey(sku)) {
            self.products.remove(sku);
            return self.products;
        } else {
            return error("No product with SKU ${sku} exists");
        }
    }

    remote function list_available_products() returns map<Product>|error {
        map<Product> availableProducts = self.products.filter(p => p.status == "available");
        return availableProducts;
    }

    remote function search_product(string sku) returns Product?|error {
        Product? product = self.products.get(sku);
        if (product != null && product.status == "available") {
            return product;
        } else {
            return error("Product with SKU ${sku} is not available");
        }
    }

    remote function add_to_cart(string userID, string sku) returns Responds|error {
        User? user = self.users.get(userID);
        Product? product = self.products.get(sku);

        if (user == null) {
            return error("User with ID ${userID} does not exist");
        }
        if (product == null || product.status != "available") {
            return error("Product with SKU ${sku} is not available");
        }

        Cart? cart = self.carts.get(userID);
        if (cart == null) {
            cart = new Cart();
            self.carts[userID] = cart;
        }
        cart.products.add(sku);
        return {message: "Product added to cart successfully"};
    }

    remote function place_order(string userID) returns Order|error {
        Cart? cart = self.carts.get(userID);
        if (cart == null || cart.products.isEmpty()) {
            return error("No items in cart for user ${userID}");
        }

        Order newOrder = new Order();
        newOrder.userID = userID;
        newOrder.products = cart.products;

        // Create an order ID and store the order
        string orderID = uuid(); // Generating a unique order ID
        self.orders[orderID] = newOrder;

        // Clear the user's cart
        self.carts.remove(userID);

        return newOrder;
    }
}

type Product record {
    string name;
    string description;
    float price;
    int stockQuantity;
    string SKU;
    string status; // "available" or "out of stock"
};

type User record {
    string userID;
    string firstName;
    string lastName;
    string role; // "customer" or "admin"
};

type Cart record {
    string[] products = [];
};

type Order record {
    string userID;
    string[] products;
};

>>>>>>> 7f6f1d99d312d75fb3ea16439a86d781a2110000