#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QList>

#include "todo.h"

class Backend : public QObject
{
    Q_OBJECT
public:
    Backend();
    ~Backend();

    Q_INVOKABLE QString getTest(){return test;}

    QString test = "lol";

    Q_INVOKABLE void insertToDo(QString title); //TODO: neccecary?
    //Q_INVOKABLE void removeToDo(QString name); //TODO: neccecary?
    Q_INVOKABLE QList<ToDo*>* getToDoList();

private:
    QList<ToDo*>* _todoList;

};

#endif // BACKEND_H
