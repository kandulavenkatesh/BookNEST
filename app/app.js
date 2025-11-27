// Import express.js
const express = require("express");
const path = require("path");

// Create express app
var app = express();

// Configure Pug templates
app.set("views", "app/views");
app.set("view engine", "pug");

// Add static files location
app.use(express.static("static"));

// Get the functions in the db.js file to use
const db = require('./services/db');

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
        const [recentBooks, statsRows, categoryRows] = await Promise.all([
            db.query(`
                SELECT
                    b.id,
                    b.title,
                    b.isbn_13,
                    DATE_FORMAT(b.created_at, '%Y-%m-%d') AS added_on,
                    COALESCE(DATE_FORMAT(b.publication_date, '%b %e, %Y'), '—') AS publication_date,
                    a.name AS author,
                    GROUP_CONCAT(DISTINCT c.name ORDER BY c.name SEPARATOR ', ') AS categories
                FROM books b
                JOIN authors a ON b.author_id = a.id
                LEFT JOIN book_categories bc ON bc.book_id = b.id
                LEFT JOIN categories c ON c.id = bc.category_id
                GROUP BY b.id
                ORDER BY b.created_at DESC
                LIMIT 5;
            `),
            db.query(`
                SELECT
                    (SELECT COUNT(*) FROM books) AS books,
                    (SELECT COUNT(*) FROM authors) AS authors,
                    (SELECT COUNT(*) FROM publishers) AS publishers,
                    (SELECT COUNT(*) FROM categories) AS categories
            `),
            db.query(`
                SELECT
                    c.name,
                    COUNT(bc.book_id) AS total
                FROM categories c
                LEFT JOIN book_categories bc ON bc.category_id = c.id
                GROUP BY c.id
                ORDER BY total DESC, c.name ASC
                LIMIT 5;
            `)
        ]);

        res.render("dashboard", {
            books: recentBooks,
            stats: statsRows[0] || {},
            categoryStats: categoryRows
        });
    } catch (err) {
        console.error("Error loading dashboard", err);
        res.status(500).send("Unable to load dashboard at this time.");
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
