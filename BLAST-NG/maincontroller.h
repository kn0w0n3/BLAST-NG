#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QWidget>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>
#include <QThread>
//#include <QProcess>
#include <QDebug>
#include <QMessageBox>
#include "readfiledatathread.h"

class MainController:  public QWidget{
    Q_OBJECT

public:
    MainController(QWidget *parent = nullptr);

signals:
    void selectedFileDataToQml(QString _fileContents);
    void threadStateToQml(QString _threadState);
    void directionsTextToQml(QString directionsText);
    void dbDirectionsTxtToQml(QString dbdirectionsTxt);

public slots:
    void selectAFile();
    void processIncomingFileData(QString);
    void relayThreadState(QString);
    void getMainInstructions();
    void getDbInstructions();

private:
    QString fileName;
    QString filePath;
    QString fileContents = "";
    QString instrctionsText = "";
    ReadFileDataThread *readFileDataThread;
};

#endif // MAINCONTROLLER_H
