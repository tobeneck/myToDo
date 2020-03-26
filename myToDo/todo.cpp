#include "todo.h"

ToDo::ToDo(QString title)
{
    this->title = title;
}

ToDo::~ToDo()
{

}

QString ToDo::getTitle()
{
    return this->title;
}
