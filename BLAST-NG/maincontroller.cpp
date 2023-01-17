#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

//Select a file
void MainController::selectAFile(){
    /*
    readFileDataThread = new ReadFileDataThread();
    connect(readFileDataThread, &ReadFileDataThread::fileData, this, &MainController::processIncomingFileData);
    connect(readFileDataThread, &ReadFileDataThread::loadDataStarted, this, &MainController::relayThreadState);
    connect(readFileDataThread, &ReadFileDataThread::loadDataStoped, this, &MainController::relayThreadState);
    connect(readFileDataThread, &ReadFileDataThread::finished, readFileDataThread, &QObject::deleteLater);
    readFileDataThread->start();
    */

    dbFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(dbFile);
    dbFileName = fileInfo.fileName().trimmed();
    dbFullFilePath = fileInfo.filePath().trimmed();
    dbFilePath = fileInfo.filePath().trimmed();
    dbFilePath.replace(dbFileName, "");
    dbFileSize = QString::number(fileInfo.size());
}

void MainController::selectAFile2(){
    seqFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(seqFile);
    seqFileName = fileInfo.fileName().trimmed();
    seqDirPath = fileInfo.filePath().trimmed();
    seqDirPath.replace(seqFileName, "");
    seqFullFilePath = fileInfo.filePath().trimmed();
    seqFileSize = QString::number(fileInfo.size());
}

void MainController::processIncomingFileData(QString textData){ 
    fileContents = textData;
    //emit selectedFileDataToQml(textData);
}

//Relay the thread state to QML to be displayed to user
void MainController::relayThreadState(QString threadState){
    emit threadStateToQml(threadState);
}

//Display the main window instructions
void MainController::getMainInstructions(void){
    QFile file(":/intructions/main_instructions.txt");
    if(!file.open(QIODevice::ReadOnly)) {
        QMessageBox::information(0, "error", file.errorString());
    }
    QTextStream in(&file);
    while(!in.atEnd()) {
        instrctionsText = in.readAll();
    }
    file.close();
    emit directionsTextToQml(instrctionsText);
}

//Display the build DB window instrucitons
void MainController::getDbInstructions(void){
    QFile file(":/intructions/build_db_instructions.txt");
    if(!file.open(QIODevice::ReadOnly)) {
        QMessageBox::information(0, "error", file.errorString());
    }
    QTextStream in(&file);
    while(!in.atEnd()) {
        instrctionsText = in.readAll();
    }
    file.close();
    emit dbDirectionsTxtToQml(instrctionsText);
}

//Build the database and keep the files organized in their own directories
void MainController::buildDatabase(QString dbType, QString _dbName){
    QProcess proc;
    QStringList args;

    if(!QDir(myDocumentsPath + "BLAST-NG\\databases\\" + _dbName.trimmed()).exists()){
        QDir().mkdir(myDocumentsPath + "BLAST-NG\\databases\\" + _dbName.trimmed());
    }
    uniqueDirForDb = myDocumentsPath + "BLAST-NG\\databases\\" +  _dbName.trimmed();

    //Set the directory for powershell and run the makeblastdb program.
    //After the files are created, they are moved to their unique directory for organization and later use
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./makeblastdb -in " + dbFullFilePath + " -out " +  _dbName + " -dbtype " + dbType.trimmed() + ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pdb" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".phr" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pin" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pjs" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pot" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".ptf" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".psq" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pto" + " -Destination " + uniqueDirForDb + " -force";

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();

    //Display the db build info in the scroll view to inform user of success or failure
    emit buildDbOutputToQml(outputAsString);

    //Add the databse name to the drop down menu
    emit dbNameTxtToQml(" " + _dbName.trimmed());
}

//May need to put this on a separate thread
void MainController::startBlastP(QString selectedDb, QString outFormat, QString eVal, QString numThreads, QString otherArgs, QString pastedSequence){
    QProcess proc;
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
    << "./blastp -db " + uniqueDirForDb + "\\" + selectedDb.trimmed() + " -query " + seqFullFilePath ;

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();

    emit blastPData2Qml(outputAsString);
}

//Get and store the path of NCBI tools and MyDocuments folder
//The BLAST-NG, NCBI, and databases folder should be created upon installation of BLAST-NG
void MainController::getMyDocumentsPath(){
    QProcess proc;
    QStringList args;
    QString text = "MyDocuments";
    args << "[Environment]::GetFolderPath('MyDocuments')";

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    myDocumentsPath = outputAsString + "\\";
    ncbiToolsPath = myDocumentsPath + "BLAST-NG\\NCBI\\";
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();

}


