#include "backend.h"

#include <QDebug>

Backend::Backend()
{
    _todoList = new QList<ToDo*>();
}

Backend::~Backend()
{

}

void Backend::insertToDo(QString title)
{
    _todoList->append(new ToDo(title));
    for(ToDo* todo : *_todoList){
        qDebug() << todo->getTitle();
    }
}

QList<ToDo*>* Backend::getToDoList()
{
    return this->_todoList;
}
