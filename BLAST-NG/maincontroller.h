#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QWidget>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>
#include <QThread>
#include <QProcess>
#include <QDebug>
#include <QMessageBox>
#include "readfiledatathread.h"
#include <cstdlib>
#include <QCoreApplication>

class MainController:  public QWidget{
    Q_OBJECT

public:
    MainController(QWidget *parent = nullptr);

signals:
    void selectedFileDataToQml(QString _fileContents);
    void threadStateToQml(QString _threadState);
    void directionsTextToQml(QString directionsText);
    void dbDirectionsTxtToQml(QString dbdirectionsTxt);
    void buildDbOutputToQml(QString buildDbText);
    void dbNameTxtToQml(QString dbName);
    void blastPData2Qml(QString blastPText);

public slots:
    void selectAFile();
    void selectAFile2();
    void processIncomingFileData(QString);
    void relayThreadState(QString);
    void getMainInstructions(void);
    void getDbInstructions(void);
    void buildDatabase(QString, QString);
    void startBlastP(QString, QString, QString, QString, QString, QString);
    void getMyDocumentsPath();

private:
    ReadFileDataThread *readFileDataThread;

    //DB file info
    QString dbFile = "";
    QString dbFileSize = "";
    QString dbFileName = "";
    QString dbFilePath = "";
    QString dbFullFilePath = "";
    QString uniqueDirForDb = "";

    //Sequence to compare file info
    QString seqFile = "";
    QString seqFileSize = "";
    QString seqFileName = "";
    QString seqDirPath = "";
    QString seqFullFilePath = "";

    QString myDocumentsPath = "";
    QString ncbiToolsPath = "";

    QString instrctionsText = "";   
    QString dbType = "";
    QString dbName = "";
    QString otherArgs = "";

    //Data from thread if needed
    QString fileContents = "";
};

#endif // MAINCONTROLLER_H
