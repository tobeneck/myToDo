#ifndef TODO_H
#define TODO_H

#include <QObject>

class ToDo : public QObject
{
    Q_OBJECT
public:
    ToDo(QString title);
    ~ToDo();

    QString getTitle();

private:
    QString title;
    bool done = false;
    QString label; //TODO: enum?
    QString list; //TODO: enum?
};

#endif // TODO_H
