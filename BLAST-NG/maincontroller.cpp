#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

//Select a database file - files with spaces om the name will give an error
void MainController::selectAFile(){
    dbFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(dbFile);
    dbFileName = fileInfo.fileName().trimmed();
    emit dbFileNameToQml(dbFileName);
    dbFullFilePath = fileInfo.filePath().trimmed();
}

//Select a sequence file - files with spaces om the name will give an error
void MainController::selectAFile2(){
    seqFile = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select File"), "/home");
    QFileInfo fileInfo(seqFile);
    seqFileName = fileInfo.fileName().trimmed();
    emit seqFileNameToQml(seqFileName);
    seqFullFilePath = fileInfo.filePath().trimmed();
}

//Select directory for storage of databases - future implementation
void MainController::selectDirectory(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    s_SelectedDirectory = dir.trimmed();
    emit dirPathToQml(s_SelectedDirectory);
    s_SelectedDirectory.clear();
}

void MainController::settingsSelectDir(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    QString thePath = dir.trimmed();
    emit settingsDirPath2Qml(thePath);
}

void MainController::selectDirSaveData(){
    QString dir = QFileDialog::getExistingDirectory(Q_NULLPTR, tr("Select Directory"), "/home", QFileDialog::ShowDirsOnly | QFileDialog::DontResolveSymlinks);
    QString thePath = dir.trimmed();
    emit selectedSaveToPath(thePath);

}

//TODO: allow user to select output directory
//Run the NCBI makeblastdb program
void MainController::buildDatabase(QString dbType, QString _dbName, QString _dbStoragePath){
    dbNameEntered = _dbName.trimmed();
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit buildDbOutputToQml("Building database: " + dbNameEntered +"\nBuild database process started @: " + dateTimeString);
    buildDBProcess = new QProcess();
    //uniqueDirForDb = "C:/BLAST-NG/databases/" + dbNameEntered + "/";
    uniqueDirForDb = _dbStoragePath + "/" + dbNameEntered + "/";
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./makeblastdb -in " + dbFullFilePath + " -out " + uniqueDirForDb + dbNameEntered + " -dbtype " + dbType.trimmed();
    buildDBProcess->connect(buildDBProcess, &QProcess::readyReadStandardOutput, this, &MainController::processBuildDbMessages);
    buildDBProcess->connect(buildDBProcess, &QProcess::readyReadStandardError, this, &MainController::processBuildDbErrMsg);
    connect(buildDBProcess, &QProcess::finished, this, &MainController::dbDoneResultsToQml);
    buildDBProcess->start("powershell", args);
    emit dbNameTxtToQml(" " + _dbName.trimmed());
    //dbFullFilePath.clear();
}

//Read the standard output from the BLAST build database program
void MainController::processBuildDbMessages(){
    q_buildDbStdOut += buildDBProcess->readAllStandardOutput().trimmed();
    s_buildDbStdout = QString(q_buildDbStdOut.trimmed());
    qDebug() << "The build db std out is: " + s_buildDbStdout;
}

//Read the standard error output from the BLAST build database program
void MainController::processBuildDbErrMsg(){
    q_buildDbStdErr += buildDBProcess->readAllStandardError().trimmed();
    s_buildDbStdErr = QString(q_buildDbStdErr);
    qDebug() << "The build db std out error is: " + s_buildDbStdErr;
}

//Update the QML GUI once the build database process has finished
void MainController::dbDoneResultsToQml(){
    //qDebug() << "IN db  done results";
    emit buildDbOutputToQml(s_buildDbStdout + "\n\n");
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit buildDbOutputToQml("Build database process finished @: " + dateTimeString + "\n\n");
    q_buildDbStdOut = "";
    s_buildDbStdout = "";
    //buildDBProcess->terminate();
}

//Start the NCBI BLASTp program
void MainController::startBlastP(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange, QString saveLocation){
    //qDebug() << "In BLAST P Function....";
    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "BLASTp";
    blast_p_Process = new QProcess();

    //Use pasted sequence<-----
    if(!pastedSequence.isEmpty()){
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastp -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence;
    blast_p_Process->connect(blast_p_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastPStdOut);
    connect(blast_p_Process, &QProcess::finished, this, &MainController::saveBlastPDataToFile);
    blast_p_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTp process started at: " + dateTimeString + "\n\n");
    }

    //Use the selected file <-----
    else if(pastedSequence.isEmpty()){
    //qDebug() << "Pasted sequence was empty......";
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastp -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath;
    blast_p_Process->connect(blast_p_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastPStdOut);
    connect(blast_p_Process, &QProcess::finished, this, &MainController::saveBlastPDataToFile);
    blast_p_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTp process started at: " + dateTimeString + "\n\n");
    }
}

//Read read the output of the BLASTp process and store the data in a variable
void MainController::processBlastPStdOut(){
    bpData += blast_p_Process->readAllStandardOutput().trimmed();
    blastPOutput = QString(bpData.trimmed());
}

//Save BLASTp data to file
void MainController::saveBlastPDataToFile(){
    //qDebug() << "In save blast p data.....";
    if(!QDir(resultsPath + selectedDbName + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\");
    }
    if(!QDir(resultsPath + selectedDbName + "\\" + scanMethod + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\" + scanMethod + "\\");
    }

    QDateTime dateTimeF = dateTimeF.currentDateTime();
    QString dateTimeStringF = dateTimeF.toString("yyyy-MM-dd_h_mm_ss_ap");
    QString filename = resultsPath + selectedDbName + "\\" + scanMethod + "\\" + selectedDbName + "_"  + dateTimeStringF +  ".txt";
    emit dataFileName2QML(selectedDbName + "_"  + dateTimeStringF +  ".txt");
    QFile file(filename);
    if (file.open(QIODevice::ReadWrite)) {
    QTextStream stream(&file);
    stream << blastPOutput;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTp Process completed at: " + dateTimeString + "\n\n");
    blast_p_Process->terminate();
}

//Start the NCBI BLASTn program
void MainController::startBlastN(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange, QString saveLocation){
    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "BLASTn";
    qDebug() << "The job title is: " << jobTitle;

    blast_n_Process = new QProcess();

    //Use pasted sequence
    if(!pastedSequence.isEmpty()){
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence;
    blast_n_Process->connect(blast_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastNStdOut);
    connect(blast_n_Process, &QProcess::finished, this, &MainController::saveBlastNDataToFile);
    blast_n_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTn process started at: " + dateTimeString + "\n\n");
    }

    //Use sequence from selected file
    else if (pastedSequence.isEmpty()){
    QStringList args;
    args<< "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath ;
    blast_n_Process->connect(blast_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastNStdOut);
    connect(blast_n_Process, &QProcess::finished, this, &MainController::saveBlastNDataToFile);
    blast_n_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTn process started at: " + dateTimeString + "\n\n");
    }
}

//Read the output of the BLASTn process and store the data in a variable
void MainController::processBlastNStdOut(){
    bnData += blast_n_Process->readAllStandardOutput().trimmed();
    blastNOutput = QString(bnData.trimmed());
}

//Save BLASTn data to file
void MainController::saveBlastNDataToFile(){
    qDebug() << "In save blast N data.....";
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
    stream << blastNOutput;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTn Process completed at: " + dateTimeString + "\n\n");
    blast_n_Process->terminate();
}

//Start the NCBI BLASTx program
void MainController::startBlastX(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange, QString saveLocation){
    qDebug() << "In BLAST X Function....";
    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "BLASTx";
    qDebug() << "The job title is: " << jobTitle;
    qDebug() << "The selected db  name is: " + selectedDbName;

    blast_x_Process = new QProcess();

    //Use pasted sequence<-----
    if(!pastedSequence.isEmpty()){
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastx -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence;
    blast_x_Process->connect(blast_x_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastXStdOut);
    connect(blast_x_Process, &QProcess::finished, this, &MainController::saveBlastXDataToFile);
    blast_x_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BlastX process started at: " + dateTimeString + "\n\n");
    }

    //Use the selected file <-----
    else if(pastedSequence.isEmpty()){
    qDebug() << "Pasted sequence was empty......";
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./blastx -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath;
    blast_x_Process->connect(blast_x_Process, &QProcess::readyReadStandardOutput, this, &MainController::processBlastXStdOut);
    connect(blast_x_Process, &QProcess::finished, this, &MainController::saveBlastXDataToFile);
    blast_x_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BlastX process started at: " + dateTimeString + "\n\n");
    }
}

//Read the standard output of the BLASTx process and store the data in a variable
void MainController::processBlastXStdOut(){
    bxData += blast_x_Process->readAllStandardOutput().trimmed();
    blastXOutput = QString(bxData.trimmed());
}

//Save BLASTx data to file
void MainController::saveBlastXDataToFile(){
    qDebug() << "In save BLASTx  data.....";
    if(!QDir(resultsPath + selectedDbName + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\");
    }
    if(!QDir(resultsPath + selectedDbName + "\\" + scanMethod + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\" + scanMethod + "\\");
    }

    QDateTime dateTimeF = dateTimeF.currentDateTime();
    QString dateTimeStringF = dateTimeF.toString("yyyy-MM-dd_h_mm_ss_ap");
    QString filename = resultsPath + selectedDbName + "\\" + scanMethod + "\\" + selectedDbName + "_"  + dateTimeStringF +  ".txt";
    emit dataFileName2QML(selectedDbName + "_"  + dateTimeStringF +  ".txt");
    QFile file(filename);
    if (file.open(QIODevice::ReadWrite)) {
    QTextStream stream(&file);
    stream << blastXOutput;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("BLASTx Process completed at: " + dateTimeString + "\n\n");
    blast_x_Process->terminate();
}

//Run the NCBI tBLASTn program
void MainController::startTBlastN(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange, QString saveLocation){
    qDebug() << "In tBLASTn function...";

    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "tBLASTn";
    qDebug() << "The job title is: " << jobTitle;
    qDebug() << "The selected db  name is: " + selectedDbName;

    t_BLAST_n_Process = new QProcess();

    //Use pasted sequence<-----
    if(!pastedSequence.isEmpty()){
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./tblastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence;
    t_BLAST_n_Process->connect(t_BLAST_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processtBlastnStdOut);
    connect(t_BLAST_n_Process, &QProcess::finished, this, &MainController::savetBlastnDataToFile);
    t_BLAST_n_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTn process started at: " + dateTimeString + "\n\n");
    }

    //Use the selected file <-----
    else if(pastedSequence.isEmpty()){
    qDebug() << "Pasted sequence was empty......";
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./tblastn -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath;
    t_BLAST_n_Process->connect(t_BLAST_n_Process, &QProcess::readyReadStandardOutput, this, &MainController::processtBlastnStdOut);
    connect(t_BLAST_n_Process, &QProcess::finished, this, &MainController::savetBlastnDataToFile);
    t_BLAST_n_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTn process started at: " + dateTimeString + "\n\n");
    }
}

//Process tBLASTn standard output
void MainController::processtBlastnStdOut(){
    tBLASTnByteArrayData = t_BLAST_n_Process->readAllStandardOutput().trimmed();
    tBLASTnStringData = QString(tBLASTnByteArrayData);
}

//Save tBLASTn data to file
void MainController::savetBlastnDataToFile(){
    qDebug() << "In save tBLASTn  data.....";
    if(!QDir(resultsPath + selectedDbName + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\");
    }
    if(!QDir(resultsPath + selectedDbName + "\\" + scanMethod + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\" + scanMethod + "\\");
    }

    QDateTime dateTimeF = dateTimeF.currentDateTime();
    QString dateTimeStringF = dateTimeF.toString("yyyy-MM-dd_h_mm_ss_ap");
    QString filename = resultsPath + selectedDbName + "\\" + scanMethod + "\\" + selectedDbName + "_"  + dateTimeStringF +  ".txt";
    emit dataFileName2QML(selectedDbName + "_"  + dateTimeStringF +  ".txt");
    QFile file(filename);
    if (file.open(QIODevice::ReadWrite)) {
    QTextStream stream(&file);
    stream << tBLASTnStringData;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTn Process completed at: " + dateTimeString + "\n\n");
    t_BLAST_n_Process->terminate();
}

//Run the NCBI tBLASTx program
void MainController::startTBlastX(QString selectedDb, QString outFormat, QString iPastedSequence, QString jobTitle, QString fSubrange, QString tSubrange, QString saveLocation){
    qDebug() << "In tBLASTx function....";

    selectedDbName = selectedDb.trimmed();
    pastedSequence = iPastedSequence.trimmed();
    scanMethod = "tBLASTx";
    qDebug() << "The job title is: " << jobTitle;
    qDebug() << "The selected db name is: " + selectedDbName;

    t_BLAST_x_Process = new QProcess();

    //Use pasted sequence<-----
    if(!pastedSequence.isEmpty()){
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./tblastx -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + pastedSequence;
    t_BLAST_x_Process->connect(t_BLAST_x_Process, &QProcess::readyReadStandardOutput, this, &MainController::processtBlastxStdOut);
    connect(t_BLAST_x_Process, &QProcess::finished, this, &MainController::savetBlastxDataToFile);
    t_BLAST_x_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTx process started at: " + dateTimeString + "\n\n");
    }

    //Use the selected file <-----
    else if(pastedSequence.isEmpty()){
    qDebug() << "Pasted sequence was empty......";
    QStringList args;
    args << "Set-Location -Path " + ncbiToolsPath + ";"
         << "./tBLASTx -db " + databasesPath + selectedDbName + "\\" + selectedDbName + " -query " + seqFullFilePath;
    t_BLAST_x_Process->connect(t_BLAST_x_Process, &QProcess::readyReadStandardOutput, this, &MainController::processtBlastxStdOut);
    connect(t_BLAST_x_Process, &QProcess::finished, this, &MainController::savetBlastxDataToFile);
    t_BLAST_x_Process->start("powershell", args);

    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTx process started at: " + dateTimeString + "\n\n");
    }
}

//Process tBLASTx standard output
void MainController::processtBlastxStdOut(){
    tBLASTxByteArrayData = t_BLAST_x_Process->readAllStandardOutput().trimmed();
    tBLASTxStringData = QString(tBLASTxByteArrayData);
}

//Save tBLASTx data to file
void MainController::savetBlastxDataToFile(){
    if(!QDir(resultsPath + selectedDbName + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\");
    }
    if(!QDir(resultsPath + selectedDbName + "\\" + scanMethod + "\\").exists()){
    QDir().mkdir(resultsPath + selectedDbName + "\\" + scanMethod + "\\");
    }

    QDateTime dateTimeF = dateTimeF.currentDateTime();
    QString dateTimeStringF = dateTimeF.toString("yyyy-MM-dd_h_mm_ss_ap");
    QString filename = resultsPath + selectedDbName + "\\" + scanMethod + "\\" + selectedDbName + "_"  + dateTimeStringF +  ".txt";
    emit dataFileName2QML(selectedDbName + "_"  + dateTimeStringF +  ".txt");
    QFile file(filename);
    if (file.open(QIODevice::ReadWrite)) {
    QTextStream stream(&file);
    stream << tBLASTxStringData;
    }
    QDateTime dateTime = dateTime.currentDateTime();
    QString dateTimeString = dateTime.toString("yyyy-MM-dd h:mm:ss ap");
    emit blastTimeLogData2Qml("tBLASTx Process completed at: " + dateTimeString + "\n\n");
    t_BLAST_x_Process->terminate();
}

//The BLAST-NG, NCBI, databases and results folders are created upon installation of BLAST-NG
//Set Directories. This is being called from a component in QML
void MainController::setDirs(){
    //docsFolder = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    ncbiToolsPath = "C:/BLAST-NG/NCBI/";
    //databasesPath = "C:/BLAST-NG/databases/";
    resultsPath = "C:/BLAST-NG/results/";
    //getSavedDatabases();
}

//Get the saved database name and populate the combo box in QML
void MainController::getSavedDatabases(){
    QDirIterator it(databasesPath, QDir::AllDirs | QDir::NoDotAndDotDot);
    while (it.hasNext()) {
        QString dir = it.next();
        QFileInfo fileInfo(dir);
        QString folderName = fileInfo.fileName();
        qDebug() << folderName;
        emit dbNameTxtToQml(" " + folderName);
    }
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

//Populate the combobox in QML with the available file names
void MainController::populateDataFiles(){
    QString t_FilePath = "";
    QString t_FileName = "";
    searchingForFile = true;
    QDirIterator it("C:/BLAST-NG/results/", QDir::NoDotAndDotDot | QDir::Files, QDirIterator::Subdirectories);

    while (it.hasNext()) {
        t_FilePath = it.next();
        t_FileName = it.fileName();
        emit dataFileName2QML(t_FileName);
    }
}

//Load the selected data file
void MainController::loadDataFile(QString selectedFile){
    QString t_FilePath = "";
    QString t_FileName = "";
    QString f_FileToOpen = "";
    searchingForFile = true;
    QDirIterator it("C:/BLAST-NG/results/", QDirIterator::Subdirectories);
    while (it.hasNext() && searchingForFile == true) {
        t_FilePath = it.next();
        t_FileName = it.fileName();

        if(t_FileName == selectedFile){
            f_FileToOpen = t_FilePath;
            searchingForFile = false;
        }
    }

    QFile sFile(f_FileToOpen);
    if(!sFile.open(QIODevice::ReadOnly)){
        //error
    }
    QTextStream in(&sFile);
    while (!in.atEnd()){
        openFileForView = in.readAll().trimmed();
    }
    sFile.close();
    emit fileViewerData2Qml(openFileForView);
    openFileForView = "";
}

//Save the path for saved databases
void MainController::saveDatabaseSettings(QString _Path){
    QFile dbSettingsFile("C:/BLAST-NG/settings/dbsettings/dbsettings.txt");
    if (dbSettingsFile.open(QIODevice::WriteOnly)) {
        QTextStream stream(&dbSettingsFile);
        stream << _Path;
    }
    dbSettingsFile.close();
    emit settingsDirPath2Qml("");
    emit updateCurSavedDbPath(_Path);
}

void MainController::loadDatabaseSettings(){
    QFile file("C:/BLAST-NG/settings/dbsettings/dbsettings.txt");
    if(!file.open(QIODevice::ReadOnly)) {
        //QMessageBox::information(0, "error", file.errorString());
    }

    QTextStream in(&file);
    while(!in.atEnd()) {
        curSavedDbPath = in.readAll();
    }
    file.close();

    if(curSavedDbPath == ""){
        databasesPath = "C:/BLAST-NG/databases/";
        emit updateCurSavedDbPath("C:/BLAST-NG/databases/");
        emit settingsDirPath2Qml("");
    }
    else{
        databasesPath = curSavedDbPath;
        emit updateCurSavedDbPath(curSavedDbPath);
        emit settingsDirPath2Qml("");
    }
    getSavedDatabases();
}
