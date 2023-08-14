#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QWidget>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>
//#include <QThread>
#include <QProcess>
#include <QDebug>
#include <QMessageBox>
#include <QDirIterator>
#include <QString>
#include <QDateTime>
#include <QStandardPaths>

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
    void dataFileName2QML(QString dataFileName);
    void fileViewerData2Qml(QString fileData);
    void settingsDirPath2Qml(QString updatedCurSavedDbPath);
    void updateCurSavedDbPath(QString curDbPath);

public slots:
    void selectAFile();
    void selectAFile2();
    void selectDirectory();
    void settingsSelectDir();

    //Build database functions
    void buildDatabase(QString, QString, QString);
    void processBuildDbMessages();
    void processBuildDbErrMsg();
    void dbDoneResultsToQml();

    //BLASTp functions
    void startBlastP(QString, QString, QString, QString, QString, QString);
    void processBlastPStdOut();
    void saveBlastPDataToFile();

    //BLASTn functions
    void startBlastN(QString, QString, QString, QString, QString, QString);
    void processBlastNStdOut();
    void saveBlastNDataToFile();

    //BLASTx functions
    void startBlastX(QString, QString, QString, QString, QString, QString);
    void processBlastXStdOut();
    void saveBlastXDataToFile();

    //tBLASTn functions
    void startTBlastN(QString, QString, QString, QString, QString, QString);
    void processtBlastnStdOut();
    void savetBlastnDataToFile();

    //tBLASTx functions
    void startTBlastX(QString, QString, QString, QString, QString, QString);
    void processtBlastxStdOut();
    void savetBlastxDataToFile();

    void setDirs();
    void getSavedDatabases();


    void getMainInstructions(void);
    void getDbInstructions(void);

    void populateDataFiles();
    void loadDataFile(QString);

    void saveDatabaseSettings(QString);
    void loadDatabaseSettings();

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

    //Pointers for dynamic memory allocation
    QProcess *blast_p_Process;
    QProcess *blast_n_Process;
    QProcess *blast_x_Process;
    QProcess *t_BLAST_n_Process;
    QProcess *t_BLAST_x_Process;
    QProcess *buildDBProcess;

    //Variables for BLASTp data
    QByteArray bpData;
    QString blastPOutput;

    //Variables for BLASTn data
    QByteArray bnData;
    QString blastNOutput;

    //Variables for BLASTx data
    QByteArray bxData;
    QString blastXOutput;

    //Variables for build database standard data
    QByteArray q_buildDbStdOut;
    QString s_buildDbStdout;

    //Variables for build database error data
    QByteArray q_buildDbStdErr;
    QString s_buildDbStdErr;

    //Variables for tBLASTn data
    QByteArray tBLASTnByteArrayData;
    QString tBLASTnStringData;

    //Variables for tBLASTx data
    QByteArray tBLASTxByteArrayData;
    QString tBLASTxStringData;

    //Variables to store info from QML about operational data
    QString dbNameEntered;
    QString s_SelectedDirectory;
    QString jobTitle;
    QString testPath;
    QString docsFolder;
    QString openFileForView = "";
    QDir currentDir;

    bool searchingForFile = false;

    QString curSavedDbPath = "";
};
#endif // MAINCONTROLLER_H
