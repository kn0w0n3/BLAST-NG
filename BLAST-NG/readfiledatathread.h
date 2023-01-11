#ifndef READFILEDATATHREAD_H
#define READFILEDATATHREAD_H
#include <QThread>
#include <QObject>
#include <QTextStream>
#include <QDebug>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>

class ReadFileDataThread: public QThread{
    Q_OBJECT

public:
    ReadFileDataThread(QThread *parent = 0);
    void run();

signals:
    void fileData(QString);
    void loadDataStarted(QString);
    void loadDataStoped(QString);

public slots:
    void selectFile();

private:
    QString file;
    QString fileContents;
    QString fileName;
    QString filePath;
    QString fileSize;
    QString incomingFileData;

    QFile fileLocation;
};

#endif // READFILEDATATHREAD_H
