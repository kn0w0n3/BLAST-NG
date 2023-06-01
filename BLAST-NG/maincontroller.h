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
#include <QDirIterator>
#include <QString>
#include <QDateTime>

class MainController:  public QWidget{
    Q_OBJECT

public:
    MainController(QWidget *parent = nullptr);

signals:
    void selectedFileDataToQml(QString _fileContents);
    void directionsTextToQml(QString directionsText);
    void dbDirectionsTxtToQml(QString dbdirectionsTxt);
    void buildDbOutputToQml(QString buildDbText);
    void dbNameTxtToQml(QString dbName);

    void blastPData2Qml(QString blastPText);
    void blastNData2Qml(QString blastNText);
    void blastTimeLogData2Qml(QString timeLogText);

    void seqFileNameToQml(QString _seqFileName);
    void dbFileNameToQml(QString _dbFileName);
    void dirPathToQml(QString _dirPath);

public slots:
    void selectAFile();
    void selectAFile2();   
    void buildDatabase(QString, QString);
    void startBlastP(QString, QString, QString, QString, QString, QString);

    void processBlastPStdOut();
    void processBlastNStdOut();

    void startBlastN(QString, QString, QString, QString, QString, QString);
    void startBlastX();
    void startTBlastN();
    void startTBlastX();
    void saveDataToFile();
    void getMyDocumentsPath();
    void getSavedDatabases();
    void processBuildDbMessages();
    void processBuildDbErrMsg();
    void dbDoneResultsToQml();
    void getMainInstructions(void);
    void getDbInstructions(void);
    void selectDirectory();

private:  
    //DB file info
    QString dbFile;
    QString dbFileSize = "";
    QString dbFileName = "";
    QString dbFilePath = "";
    QString dbFullFilePath_L;
    QString dbFullFilePath = "";
    QString finalDirForDb = "";
    QString uniqueDirForDb = "";

    //Sequence to compare file info
    QString seqFile = "";
    QString seqFileSize = "";
    QString seqFileName = "";
    QString seqDirPath = "";
    QString seqFullFilePath = "";

    QString myDocumentsPath = "";
    QString ncbiToolsPath = "";
    QString databasesPath = "";
    QString resultsPath = "";

    QString instrctionsText = "";   
    QString dbType = "";
    QString selectedDbName = "";
    QString otherArgs = "";

    QString pastedSequence = "";
    QString outputFormat = "";

    QString scanMethod = "";

    //Data from thread if needed
    QString fileContents = "";

    QProcess blast_p_Process;
    QProcess blast_n_Process;
    QProcess *buildDBProcess;

    //Store BLAST output
    QByteArray bpData;
    QString blastPOutput;
    QByteArray bnData;
    QString blastNOutput;

    QByteArray q_buildDbStdOut;
    QString s_buildDbStdout;

    QByteArray q_buildDbStdErr;
    QString s_buildDbStdErr;

    QString dbNameEntered;
    QString s_SelectedDirectory;
    QString jobTitle;
    QString testPath;

};

#endif // MAINCONTROLLER_H
