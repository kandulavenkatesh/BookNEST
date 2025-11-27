// Import express.js
const express = require("express");
const path = require("path");

// Create express app
var app = express();

// Parse JSON payloads for API routes
app.use(express.json());

// Configure Pug templates
app.set("views", "app/views");
app.set("view engine", "pug");

// Add static files location
app.use(express.static("static"));

// Get the functions in the db.js file to use
const db = require('./services/db');
const { Book } = require("./models/book");
const bookModel = new Book();

// Create a route for root - /
app.get("/", function(req, res) {
    res.render("home");
});

// Create a route for login
app.get("/login", function(req, res) {
    res.render("login");
});

// Create a route for registration
app.get("/register", function(req, res) {
    res.render("register");
});

// Create a route for dashboard
app.get("/dashboard", async function(req, res) {
    try {
        const search = req.query.search || '';
        const categoryFilter = req.query.category ? Number(req.query.category) : null;
        const dashboardData = await bookModel.getDashboardData(search, categoryFilter);
        res.render("dashboard", dashboardData);
    } catch (err) {
        console.error("Error loading dashboard", err);
        res.status(500).send("Unable to load dashboard at this time.");
    }
});

// Book details page
app.get("/books/:id", async function(req, res) {
    const bookId = Number(req.params.id);
    if (!bookId) {
        return res.status(400).send("Invalid book id");
    }

    try {
        const { book, categories } = await bookModel.getBookDetail(bookId);
        if (!book) {
            return res.status(404).send("Book not found");
        }

        res.render("book-detail", {
            book,
            categories
        });
    } catch (err) {
        console.error("Error loading book details", err);
        res.status(500).send("Unable to load book details right now.");
    }
});

// Create a route for testing the db
app.get("/db_test", function(req, res) {
    // Assumes a table called test_table exists in your database
    sql = 'select * from test_table';
    db.query(sql).then(results => {
        console.log(results);
        res.send(results)
    });
});

// Create a route for /goodbye
// Responds to a 'GET' request
app.get("/goodbye", function(req, res) {
    res.send("Goodbye world!");
});

// Create a dynamic route for /hello/<name>, where name is any value provided by user
// At the end of the URL
// Responds to a 'GET' request
app.get("/hello/:name", function(req, res) {
    // req.params contains any parameters in the request
    // We can examine it in the console for debugging purposes
    console.log(req.params);
    //  Retrieve the 'name' parameter and use it in a dynamically generated page
    res.send("Hello " + req.params.name);
});

// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});
