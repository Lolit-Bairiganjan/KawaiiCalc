#pragma once
#include <QObject>
#include <QString>
#include <string>
#include <cctype>

class CalcEngine : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString displayText READ displayText NOTIFY displayTextChanged)

public:
    explicit CalcEngine(QObject *parent = nullptr);

    QString displayText() const;

    Q_INVOKABLE void appendChar(const QString &val);
    Q_INVOKABLE void clear();
    Q_INVOKABLE void backspace();
    Q_INVOKABLE void calculate();

signals:
    void displayTextChanged();

private:
    QString m_display;

    int precedence(char op);
    double applyOp(double a, double b, char op);
    double evaluateInfix(const std::string &expr);
};