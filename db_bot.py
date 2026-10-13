import json
import sqlite3
import sys
import time
from pathlib import Path

import anthropic

MODEL = "claude-haiku-5-5"
DB_PATH = "bot.db"
SCHEMA = Path("setup.sql").read_text()

with open("config.json") as f:
    client = anthropic.Anthropic(api_key=json.load(f)["claude_key"])

# zero_shot: schema only
# single_domain: one example question from this database
# cross_domain: one example question from a different database
EXAMPLES = {
    "zero_shot": "",
    "single_domain": (
        "Example:\n"
        "Q: How many appointments did customer 5 book?\n"
        "SQL: SELECT COUNT(*) FROM appointments WHERE customer_id = 5;\n"
    ),
    "cross_domain": (
        "Example from another database:\n"
        "Q: Which books were checked out by member 3?\n"
        "SQL: SELECT title FROM checkouts JOIN books ON books.id = checkouts.book_id WHERE member_id = 3;\n"
    ),
}


def ask_claude(prompt):
    msg = client.messages.create(
        model=MODEL,
        max_tokens=1000,
        messages=[{"role": "user", "content": prompt}],
    )
    return "".join(b.text for b in msg.content if b.type == "text").strip()


def question_to_sql(question, strategy):
    prompt = f"""You translate questions into SQLite queries.

Schema:
{SCHEMA}

{EXAMPLES[strategy]}
Return only one SQL query. No explanation, no markdown.

Question: {question}"""
    sql = ask_claude(prompt)
    return sql.replace("```sql", "").replace("```", "").strip()


def run_sql(sql):
    conn = sqlite3.connect(DB_PATH)
    try:
        cur = conn.execute(sql)
        cols = [d[0] for d in cur.description] if cur.description else []
        return cols, cur.fetchall(), None
    except sqlite3.Error as e:
        return [], [], str(e)
    finally:
        conn.close()


def rows_to_answer(question, sql, cols, rows):
    prompt = f"""Question: {question}
SQL used: {sql}
Columns: {cols}
Rows: {rows}

Answer the question in plain English, concisely, using only these results."""
    return ask_claude(prompt)


def main():
    strategy = sys.argv[1] if len(sys.argv) > 1 else "zero_shot"
    if strategy not in EXAMPLES:
        sys.exit(f"Strategy must be one of: {', '.join(EXAMPLES)}")

    log_path = f"responses_{strategy}_{time.strftime('%Y%m%d-%H%M%S')}.json"
    records = []

    while True:
        question = input("Question (blank to quit): ").strip()
        if not question:
            break

        sql = question_to_sql(question, strategy)
        cols, rows, error = run_sql(sql)

        if error:
            answer = f"SQL error: {error}"
        else:
            answer = rows_to_answer(question, sql, cols, rows)

        print(answer)
        records.append({"question": question, "sql": sql, "error": error, "answer": answer})
        Path(log_path).write_text(json.dumps(records, indent=2))


if __name__ == "__main__":
    main()