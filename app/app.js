// Import express.js
const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const session = require("express-session");
const { User } = require("./models/user");
const bcrypt = require("bcryptjs");
const multer = require("multer");


// Create express app
var app = express();

// Parse JSON payloads for API routes
app.use(express.json());

// Body parsers
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static("static"));
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "static/uploads/books");
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname);
  }
});

const upload = multer({ storage });



// Configure Pug templates
app.set("views", "app/views");
app.set("view engine", "pug");


// Session and cookies
app.use(cookieParser());
const oneDay = 1000 * 60 * 60 * 24;
app.use(
  session({
    secret: "secretkeysdfjsflyoifasd",
    saveUninitialized: true,
    resave: false,
    cookie: { maxAge: oneDay },
  })
);

// Add static files location
app.use(express.static("static"));

// Get the functions in the db.js file to use
const db = require('./services/db');
const { Book } = require("./models/book");
const bookModel = new Book();

// Make session available in all pug files
app.use((req, res, next) => {
  res.locals.uid = req.session.uid;
  res.locals.loggedIn = req.session.loggedIn;
  next();
});


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

// Handle signup / set-password
app.post("/set-password", async (req, res) => {
  const { email, username, password } = req.body;
  if (!email || !username || !password) {
    return res.status(400).send("All fields are required.");
  }

  try {
    // Check existing by email or username
    const existing = await db.query(
      "SELECT * FROM Users WHERE email = ? OR username = ?",
      [email, username]
    );
    const user = new User(email, username);

    if (existing.length > 0) {
      // update password for existing
      user.id = existing[0].user_id;
      await user.setUserPassword(password);
      return res.send("Password updated successfully.");
    }

    // create new
    await user.addUser(password);
    res.send("Account created! Please log in.");
  } catch (err) {
    console.error("Error in /set-password:", err);
    res.status(500).send("Internal Server Error");
  }
});

// Handle login
// Handle login
app.post("/authenticate", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).send("Email and password are required.");

  const user = new User(email);

  try {
    const uId = await user.getIdFromEmail();
    if (!uId) return res.status(401).send("Invalid email");

    user.id = uId;
    const match = await user.authenticate(password);
    if (!match) return res.status(401).send("Invalid password");

    // session
    req.session.uid = uId;
    req.session.loggedIn = true;

    // ✅ ROLE CHECK
    if (uId === 1) {
      return res.redirect("/dashboard");          // admin
    } else {
      return res.redirect("/customer-dashboard"); // customer
    }

  } catch (err) {
    console.error("Error in /authenticate:", err);
    res.status(500).send("Internal Server Error");
  }
});


// Handle logout
app.get("/logout", (req, res) => {
  req.session.destroy((err) => {
    if (err) console.error(err);
    res.redirect("/login");
  });
});

// Create a route for dashboard
app.get("/dashboard", async function(req, res) {
    if (!req.session.loggedIn || req.session.uid !== 1) {
        return res.redirect("/login");
    }

    try {
        const search = req.query.search || '';
        const categoryFilter = req.query.category ? Number(req.query.category) : null;
        const dashboardData = await bookModel.getDashboardData(search, categoryFilter);
        res.render("dashboard", dashboardData);
    } catch (err) {
        console.error("Error loading dashboard", err);
        res.status(500).send("Unable to load dashboard.");
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


app.post("/admin/books", upload.single("cover"), async function (req, res) {
    try {
        const bookModel = new Book();

        await bookModel.addBook(req.body, req.file);

        res.redirect("/dashboard");
    } catch (err) {
        console.error("Create book error:", err);
        res.status(500).send("Failed to create book");
    }
});
app.get("/admin/books/create", async function (req, res) {
    try {
        const authors = await db.query("SELECT id, name FROM authors");
        const publishers = await db.query("SELECT id, name FROM publishers");
        const categories = await db.query("SELECT id, name FROM categories");

        res.render("add-book", {
            authors,
            publishers,
            categories
        });
    } catch (err) {
        console.error(err);
        res.status(500).send("Unable to load page");
    }
});


// Start server on port 3000
app.listen(3000,function(){
    console.log(`Server running at http://127.0.0.1:3000/`);
});
