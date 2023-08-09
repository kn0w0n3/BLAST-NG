#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

//Select a file
void MainController::selectAFile(){
    dbFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(dbFile);
    dbFileName = fileInfo.fileName().trimmed();

    emit dbFileNameToQml(dbFileName);
    dbFullFilePath = fileInfo.filePath().trimmed();

    dbFilePath = fileInfo.filePath().trimmed();
    dbFilePath.replace(dbFileName, "");
    //dbFileSize = QString::number(fileInfo.size());

    qDebug() << "The selected full db file path is " << dbFullFilePath;
}

//File and folder names with spaces will give an error.
void MainController::selectAFile2(){
    seqFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(seqFile);

    seqFileName = fileInfo.fileName().trimmed();
    emit seqFileNameToQml(seqFileName);

    //seqDirPath = fileInfo.filePath().trimmed();
    //seqDirPath.replace(seqFileName, "");
    seqFullFilePath = fileInfo.filePath().trimmed();
    //seqFileSize = QString::number(fileInfo.size());

    qDebug() << "The sequence full file path is " << seqFullFilePath;
}

//TODO put all the files in a folder and then transfer the folder. Also allow user to select output directory
//Build the database and keep the files organized in their own directories
void MainController::buildDatabase(QString dbType, QString _dbName){
    dbNameEntered = _dbName.trimmed();
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit buildDbOutputToQml("Building database: " + dbNameEntered +"\nBuild database process started @: " + dateTimeString);

    if(!QDir(docsFolder + "BLAST-NG\\databases\\").exists()){
        //qDebug() << "Should be making directory: " + myDocumentsPath + "BLAST-NG\\databases\\";
         QDir().mkdir(docsFolder + "BLAST-NG\\databases\\");
    }

    uniqueDirForDb = docsFolder + "BLAST-NG\\databases\\" + dbNameEntered + "\\";
    //finalDirForDb = myDocumentsPath + "BLAST-NG\\databases\\";

    //Set the directory for powershell and run the makeblastdb program.
    //After the files are created, they are moved to their unique directory for organization and later use
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./makeblastdb -in " + dbFullFilePath + " -out " + uniqueDirForDb + dbNameEntered + " -dbtype " + dbType.trimmed();
         //<< "Move-Item -Path " + uniqueDirForDb + " -Destination " + finalDirForDb + " -force";
    buildDBProcess = new QProcess();
    buildDBProcess->connect(buildDBProcess, &QProcess::readyReadStandardOutput, this, &MainController::processBuildDbMessages);
    buildDBProcess->connect(buildDBProcess, &QProcess::readyReadStandardError, this, &MainController::processBuildDbErrMsg);
    //connect(buildDBProcess, (void(QProcess::*)(int))&QProcess::finished, [=]{dbDoneResultsToQml();});
    connect(buildDBProcess, &QProcess::finished, this, &MainController::dbDoneResultsToQml);
    buildDBProcess->start("powershell", args);

    emit dbNameTxtToQml(" " + _dbName.trimmed());
    //dbFullFilePath.clear();
}

//Run Blastp
void MainController::startBlastP(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange){
    qDebug() << "In BLAST P Function....";
    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "BLASTp";
    qDebug() << "The job title is: " << jobTitle;
    qDebug() << "The selected db  name is: " + selectedDbName;

    //Use pasted sequence<-----
    if(!pastedSequence.isEmpty()){
    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
    << "./blastp -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence ;
    blast_p_Process.connect(&blast_p_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastPStdOut);
    //connect(&blast_p_Process, (void(QProcess::*)(int))&QProcess::finished, [=]{saveDataToFile();});
    connect(&blast_p_Process, &QProcess::finished, this, &MainController::saveDataToFile);
    blast_p_Process.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit emit blastTimeLogData2Qml("BlastP process started at: " + dateTimeString + "\n\n");
    }

    //Use the selected file <-----
    else if(pastedSequence.isEmpty()){
    qDebug() << "Pasted sequence was empty......";
    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastp -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath;
    blast_p_Process.connect(&blast_p_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastPStdOut);
    //connect(&blast_p_Process, (void(QProcess::*)(int))&QProcess::finished, [=]{saveDataToFile();});
    connect(&blast_p_Process, &QProcess::finished, this, &MainController::saveDataToFile);
    blast_p_Process.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit emit blastTimeLogData2Qml("BlastP process started at: " + dateTimeString + "\n\n");
    }
}

//Read read the output of the BLASTp process and store the data in a variable
void MainController::processBlastPStdOut(){
    bpData += blast_p_Process.readAllStandardOutput().trimmed();

    blastPOutput = QString(bpData.trimmed());
    qDebug() << "The BLAST P output is: " + blastPOutput;
}

void MainController::startBlastN(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange){
    qDebug() << "In BLASTN function.";

    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "BLASTn";
    qDebug() << "The job title is: " << jobTitle;

    //Use pasted sequence
    if(!pastedSequence.isEmpty()){
    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath ;
    blast_n_Process.connect(&blast_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastNStdOut);
    //connect(&blast_n_Process, (void(QProcess::*)(int))&QProcess::finished, [=]{saveDataToFile();});
    connect(&blast_n_Process, &QProcess::finished, this, &MainController::saveDataToFile);
    blast_n_Process.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit emit blastTimeLogData2Qml("BLASTn process started at: " + dateTimeString + "\n\n");
    }

    //Use sequence from selected file
    else if (pastedSequence.isEmpty()){
    //This path needs to be where the NCBI blast programs are located. The db.fasta and seq.fasta files do not need to be in here
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath ;
    blast_n_Process.connect(&blast_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastNStdOut);
    //connect(&blast_n_Process, (void(QProcess::*)(int))&QProcess::finished, [=]{saveDataToFile();});
    connect(&blast_n_Process, &QProcess::finished, this, &MainController::saveDataToFile);
    blast_n_Process.start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit emit blastTimeLogData2Qml("BLASTn process started at: " + dateTimeString + "\n\n");
    }
}

//Read the output of the BLASTn process and store the data in a variable
void MainController::processBlastNStdOut(){
    bnData += blast_n_Process.readAllStandardOutput().trimmed();
    blastNOutput = QString(bnData.trimmed());
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
    emit blastTimeLogData2Qml("Process completed at: " + dateTimeString + "\n\n");
}

//Get and store the path of NCBI tools and MyDocuments folder
//The BLAST-NG, NCBI, and databases folder should be created upon installation of BLAST-NG
void MainController::getMyDocumentsPath(){
    /*
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
    */
    docsFolder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    qDebug() << "THE DOCS PATH IS: " + docsFolder;
    //myDocumentsPath = outputAsString + "\\";
    ncbiToolsPath = docsFolder + "\\BLAST-NG\\NCBI\\";
    databasesPath = docsFolder + "\\BLAST-NG\\databases\\";
    resultsPath = docsFolder + "\\BLAST-NG\\results\\";

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
    q_buildDbStdOut += buildDBProcess->readAllStandardOutput().trimmed();
    s_buildDbStdout = QString(q_buildDbStdOut.trimmed());
    qDebug() << "STD OUTPUT IS: " + s_buildDbStdout;
    //emit buildDbOutputToQml(s_buildDbStdout);
}

void MainController::processBuildDbErrMsg(){
    q_buildDbStdErr += buildDBProcess->readAllStandardError().trimmed();
    s_buildDbStdErr = QString(q_buildDbStdErr);
    qDebug() << "ERROR MESSAGE IS: " + s_buildDbStdErr;
}

void MainController::dbDoneResultsToQml(){
    qDebug() << "Trying to send db results";
    emit buildDbOutputToQml(s_buildDbStdout + "\n\n");
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit buildDbOutputToQml("Build database process finished @: " + dateTimeString + "\n\n");
    q_buildDbStdOut = "";
    s_buildDbStdout = "";
    buildDBProcess->terminate();
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

void MainController::selectDirectory(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    s_SelectedDirectory = dir.trimmed();

    emit dirPathToQml(s_SelectedDirectory);
    qDebug() << "The selected directory is: " +  s_SelectedDirectory;
    s_SelectedDirectory.clear();
}
