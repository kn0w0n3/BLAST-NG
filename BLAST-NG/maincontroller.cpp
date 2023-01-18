#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

//Select a file
void MainController::selectAFile(){
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

//Build the database and keep the files organized in their own directories
void MainController::buildDatabase(QString dbType, QString _dbName){
    dbNameEntered = _dbName.trimmed();
    emit buildDbOutputToQml("Building database... \n");
    //QProcess proc;
    QStringList args;

    if(!QDir(myDocumentsPath + "BLAST-NG\\databases\\" + dbNameEntered).exists()){
        QDir().mkdir(myDocumentsPath + "BLAST-NG\\databases\\" + dbNameEntered);
    }
    uniqueDirForDb = myDocumentsPath + "BLAST-NG\\databases\\" + dbNameEntered;

    //Set the directory for powershell and run the makeblastdb program.
    //After the files are created, they are moved to their unique directory for organization and later use
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./makeblastdb -in " + dbFullFilePath + " -out " +  dbNameEntered + " -dbtype " + dbType.trimmed() + ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pdb" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".phr" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pin" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pjs" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pot" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".ptf" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".psq" + " -Destination " + uniqueDirForDb + " -force" ";"
         << "Move-Item -Path " + ncbiToolsPath  + _dbName + ".pto" + " -Destination " + uniqueDirForDb + " -force";

    buildDBProcess.connect(&buildDBProcess, &QProcess::readyReadStandardOutput, this, &MainController::processBuildDbMessages);
    connect(&buildDBProcess, (void(QProcess::*)(int))&QProcess::finished, [=]{dbDoneResultsToQml();});
    buildDBProcess.start("powershell", args);
    emit dbNameTxtToQml(" " + _dbName.trimmed());
}

//Run Blastp
void MainController::startBlastP(QString selectedDb, QString outFormat, QString eVal, QString numThreads, QString otherArgs, QString pastedSequence){
    selectedDbName = selectedDb.trimmed();
    scanMethod = "BLASTp";
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
    << "./blastp -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath ;
    blast_p_Process.connect(&blast_p_Process, &QProcess::readyReadStandardOutput, this, &MainController::saveBlastPReply);
    connect(&blast_p_Process, (void(QProcess::*)(int))&QProcess::finished, [=]{saveDataToFile();});
    blast_p_Process.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit emit blastPData2Qml("Blastp process started at: " + dateTimeString + "\n\n");
}

void MainController::saveBlastPReply(){
    bpData += blast_p_Process.readAllStandardOutput();
    blastPOutput = QString(bpData.trimmed());
}

void MainController::startBlastN(){
    qDebug() << "In BLASTN function.";
    /*
    QProcess proc;
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    //args<< "Set-Location -Path " + ncbiToolsPath + ";"
    //<< "./blastp -db " + uniqueDirForDb + "\\" + selectedDb.trimmed() + " -query " + seqFullFilePath ;

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();
*/
}

void MainController::startBlastX(){
    qDebug() << "In BLASTX function..";
    /*
    QProcess proc;
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    //args<< "Set-Location -Path " + ncbiToolsPath + ";"
    //<< "./blastp -db " + uniqueDirForDb + "\\" + selectedDb.trimmed() + " -query " + seqFullFilePath ;

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();
*/
}

void MainController::startTBlastN(){
    qDebug() << "In tBLASTn function...";
    /*
    QProcess proc;
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    //args<< "Set-Location -Path " + ncbiToolsPath + ";"
    //<< "./blastp -db " + uniqueDirForDb + "\\" + selectedDb.trimmed() + " -query " + seqFullFilePath ;

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();
*/
}

void MainController::startTBlastX(){
    qDebug() << "In tBLASTx function....";
    /*
    QProcess proc;
    QStringList args;

    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    //args<< "Set-Location -Path " + ncbiToolsPath + ";"
    //<< "./blastp -db " + uniqueDirForDb + "\\" + selectedDb.trimmed() + " -query " + seqFullFilePath ;

    proc.start("powershell", args);
    proc.waitForFinished();
    QByteArray output = proc.readAll();

    QString outputAsString = QString(output.trimmed());
    QByteArray errorOutput = proc.readAllStandardError();
    QByteArray outputStandard = proc.readAllStandardOutput();
*/
}

//Save the Blastp data to file
void MainController::saveDataToFile(){
    if(!QDir(resultsPath + selectedDbName + "\\").exists()){
        QDir().mkdir(resultsPath + selectedDbName + "\\");
    }
    if(!QDir(resultsPath + selectedDbName + "\\" + scanMethod + "\\").exists()){
        QDir().mkdir(resultsPath + selectedDbName + "\\" + scanMethod + "\\");
    }

    QDateTime dateTimeF = dateTimeF.currentDateTime();
    QString dateTimeStringF = dateTimeF.toString("yyyy-MM-dd_h_mm_ss_ap");
    QString filename = resultsPath + selectedDbName + "\\" + scanMethod + "\\" + selectedDbName + "_"  + dateTimeStringF +  ".txt";
    QFile file(filename);
    if (file.open(QIODevice::ReadWrite)) {
        QTextStream stream(&file);
        stream << blastPOutput;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastPData2Qml("BlastP process completed at: " + dateTimeString + "\n\n");
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
    //QByteArray errorOutput = proc.readAllStandardError();
    //QByteArray outputStandard = proc.readAllStandardOutput();

    QString outputAsString = QString(output.trimmed());
    myDocumentsPath = outputAsString + "\\";
    ncbiToolsPath = myDocumentsPath + "BLAST-NG\\NCBI\\";
    databasesPath = myDocumentsPath + "BLAST-NG\\databases\\";
    resultsPath = myDocumentsPath + "BLAST-NG\\results\\";

    getSavedDatabases();
}

void MainController::getSavedDatabases(){
    QDirIterator it(databasesPath, QDir::AllDirs | QDir::NoDotAndDotDot);
    while (it.hasNext()) {
        QString dir = it.next();
        QFileInfo fileInfo(dir);
        QString folderName = fileInfo.fileName();
        qDebug() << folderName;

        //Add the database names to the drop down menu
        emit dbNameTxtToQml(" " + folderName);
    }
}

void MainController::processBuildDbMessages(){
    q_buildDbStdOut += buildDBProcess.readAllStandardOutput();
    s_buildDbStdout = QString(q_buildDbStdOut.trimmed());
}

void MainController::dbDoneResultsToQml(){
    emit buildDbOutputToQml(s_buildDbStdout + "\n\n");
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
