#ifndef LOG_H
#define LOG_H
#include <QtCore/qstring.h>

namespace Log
{
    QString prettyProductInfoWrapper();
    void setup(const QString &app,int level = 4);
}

#endif // LOG_H
