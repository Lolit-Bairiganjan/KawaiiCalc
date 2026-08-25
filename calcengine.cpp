#include "calcengine.h"
#include <stack>
#include <string>
#include <cctype>

CalcEngine::CalcEngine(QObject *parent) : QObject(parent), m_display("") {}

QString CalcEngine::displayText() const {
    return m_display.isEmpty() ? "0" : m_display;
}

void CalcEngine::appendChar(const QString &val) {
    m_display += val;
    emit displayTextChanged();
}

void CalcEngine::clear() {
    m_display.clear();
    emit displayTextChanged();
}

void CalcEngine::backspace() {
    if (!m_display.isEmpty()) {
        m_display.chop(1);
        emit displayTextChanged();
    }
}

int CalcEngine::precedence(char op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
}

double CalcEngine::applyOp(double a, double b, char op) {
    switch (op) {
        case '+': return a + b;
        case '-': return a - b;
        case '*': return a * b;
        case '/': return b != 0.0 ? (a / b) : 0.0;
    }
    return 0.0;
}

double CalcEngine::evaluateInfix(const std::string &expr) {
    std::stack<double> values;
    std::stack<char> ops;

    for (size_t i = 0; i < expr.length(); ++i) {
        if (expr[i] == ' ') continue;

        if (std::isdigit(expr[i]) || expr[i] == '.') {
            double val = 0.0;
            double factor = 1.0;
            bool decimal = false;

            while (i < expr.length() && (std::isdigit(expr[i]) || expr[i] == '.')) {
                if (expr[i] == '.') {
                    decimal = true;
                } else if (!decimal) {
                    val = (val * 10.0) + (expr[i] - '0');
                } else {
                    factor *= 0.1;
                    val += (expr[i] - '0') * factor;
                }
                i++;
            }
            values.push(val);
            i--;
        }
        else if (expr[i] == '(') {
            ops.push('(');
        }
        else if (expr[i] == ')') {
            while (!ops.empty() && ops.top() != '(') {
                if (values.size() < 2) return 0;
                double val2 = values.top(); values.pop();
                double val1 = values.top(); values.pop();
                char op = ops.top(); ops.pop();
                values.push(applyOp(val1, val2, op));
            }
            if (!ops.empty()) ops.pop(); // Remove '('
        }
        else if (expr[i] == '+' || expr[i] == '-' || expr[i] == '*' || expr[i] == '/') {
            while (!ops.empty() && precedence(ops.top()) >= precedence(expr[i])) {
                if (values.size() < 2) return 0;
                double val2 = values.top(); values.pop();
                double val1 = values.top(); values.pop();
                char op = ops.top(); ops.pop();
                values.push(applyOp(val1, val2, op));
            }
            ops.push(expr[i]);
        }
    }

    while (!ops.empty()) {
        if (values.size() < 2) break;
        double val2 = values.top(); values.pop();
        double val1 = values.top(); values.pop();
        char op = ops.top(); ops.pop();
        values.push(applyOp(val1, val2, op));
    }

    return values.empty() ? 0 : values.top();
}

void CalcEngine::calculate() {
    if (m_display.isEmpty()) return;
    double result = evaluateInfix(m_display.toStdString());
    m_display = QString::number(result);
    emit displayTextChanged();
}