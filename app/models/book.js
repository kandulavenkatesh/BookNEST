// Get the functions in the db.js file to use
const db = require("../services/db");

class Book {
    // Id of the book (optional, used for detail lookups)
    id;
    // Optional search text for dashboard queries
    search;
    // Optional category filter for dashboard queries
    categoryId;

    constructor({ id = null, search = "", categoryId = null } = {}) {
        this.id = id;
        this.search = search;
        this.categoryId = categoryId;
    }

    // Dashboard listing data
    async getDashboardData(search = this.search, categoryId = this.categoryId) {
        const whereClauses = [];
        const params = [];
        const trimmedSearch = search.trim();

        if (trimmedSearch) {
            const like = `%${trimmedSearch}%`;
            whereClauses.push("(b.title LIKE ? OR a.name LIKE ? OR b.isbn_13 LIKE ? OR b.isbn_10 LIKE ?)");
            params.push(like, like, like, like);
        }

        if (categoryId) {
            whereClauses.push("c_filter.id = ?");
            params.push(Number(categoryId));
        }

        const whereSql = whereClauses.length ? `WHERE ${whereClauses.join(" AND ")}` : "";

        const [recentBooks, statsRows, categoryRows, allCategories] = await Promise.all([
            db.query(
                `
                SELECT
                    b.id,
                    b.title,
                    b.isbn_13,
                    b.cover_image_url,
                    DATE_FORMAT(b.created_at, '%Y-%m-%d') AS added_on,
                    COALESCE(DATE_FORMAT(b.publication_date, '%b %e, %Y'), '—') AS publication_date,
                    a.name AS author,
                    GROUP_CONCAT(DISTINCT c.name ORDER BY c.name SEPARATOR ', ') AS categories
                FROM books b
                JOIN authors a ON b.author_id = a.id
                LEFT JOIN book_categories bc ON bc.book_id = b.id
                LEFT JOIN categories c ON c.id = bc.category_id
                ${
                    categoryId
                        ? "LEFT JOIN book_categories bc_filter ON bc_filter.book_id = b.id LEFT JOIN categories c_filter ON c_filter.id = bc_filter.category_id"
                        : ""
                }
                ${whereSql}
                GROUP BY b.id
                ORDER BY b.created_at DESC
                LIMIT 20;
            `,
                params
            ),
            db.query(
                `
                SELECT
                    (SELECT COUNT(*) FROM books) AS books,
                    (SELECT COUNT(*) FROM authors) AS authors,
                    (SELECT COUNT(*) FROM publishers) AS publishers,
                    (SELECT COUNT(*) FROM categories) AS categories
                `
            ),
            db.query(
                `
                SELECT
                    c.name,
                    COUNT(bc.book_id) AS total
                FROM categories c
                LEFT JOIN book_categories bc ON bc.category_id = c.id
                GROUP BY c.id
                ORDER BY total DESC, c.name ASC
                LIMIT 5;
                `
            ),
            db.query(`SELECT id, name FROM categories ORDER BY name ASC;`),
        ]);

        return {
            books: recentBooks,
            stats: statsRows[0] || {},
            categoryStats: categoryRows,
            filters: { search: trimmedSearch, category: categoryId },
            allCategories,
        };
    }

    // Book details data
    async getBookDetail(bookId = this.id) {
        const [bookRows, categoryRows] = await Promise.all([
            db.query(
                `
                SELECT
                    b.id,
                    b.title,
                    b.subtitle,
                    b.author_id,
                    a.name AS author_name,
                    b.publisher_id,
                    p.name AS publisher_name,
                    b.isbn_10,
                    b.isbn_13,
                    b.language,
                    b.page_count,
                    b.format,
                    b.cover_image_url,
                    b.description,
                    DATE_FORMAT(b.publication_date, '%Y-%m-%d') AS publication_date_input,
                    DATE_FORMAT(b.created_at, '%Y-%m-%d %H:%i') AS created_at,
                    DATE_FORMAT(b.updated_at, '%Y-%m-%d %H:%i') AS updated_at
                FROM books b
                JOIN authors a ON a.id = b.author_id
                LEFT JOIN publishers p ON p.id = b.publisher_id
                WHERE b.id = ?
                LIMIT 1;
                `,
                [bookId]
            ),
            db.query(
                `
                SELECT
                    c.id,
                    c.name,
                    CASE WHEN bc.category_id IS NOT NULL THEN 1 ELSE 0 END AS selected
                FROM categories c
                LEFT JOIN book_categories bc ON bc.category_id = c.id AND bc.book_id = ?
                ORDER BY c.name ASC;
                `,
                [bookId]
            ),
        ]);

        return {
            book: bookRows[0] || null,
            categories: categoryRows,
        };
    }
}

module.exports = {
    Book,
};
