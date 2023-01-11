#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

void MainController::selectAFile(){

    readFileDataThread = new ReadFileDataThread();
    connect(readFileDataThread, &ReadFileDataThread::fileData, this, &MainController::processIncomingFileData);
    connect(readFileDataThread, &ReadFileDataThread::loadDataStarted, this, &MainController::relayThreadState);
    connect(readFileDataThread, &ReadFileDataThread::loadDataStoped, this, &MainController::relayThreadState);
    connect(readFileDataThread, &ReadFileDataThread::finished, readFileDataThread, &QObject::deleteLater);
    readFileDataThread->start();

    /*
    qDebug() << "In file read funtion";
    QString file = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select Directory"), "/home");
    QThread::msleep(100);
    QFileInfo fileInfo(file);
    fileName = fileInfo.fileName();
    QFile fileLocation(file);
    filePath = fileInfo.filePath();
    QThread::msleep(100);

    if (fileLocation.open(QIODevice::ReadOnly)){
        //qDebug() << "In file read funtion if statement";
        QTextStream fileContentsStream(&fileLocation);
        while (!fileContentsStream.atEnd()){
            fileContents = fileContentsStream.readAll();
            QThread::msleep(500);

        }
        fileLocation.close();
        QThread::msleep(100);
        //qDebug() << fileContents;
        //emit gBankFileData_T(gBankFileData);
        //fileContents = "";
        emit selectedFileDataToQml(fileContents);
        QThread::msleep(100);
    }
    */
}

void MainController::processIncomingFileData(QString textData){ 
    fileContents = textData;
    //emit selectedFileDataToQml(textData);
    //QThread::msleep(25);
}

void MainController::relayThreadState(QString threadState){
    emit threadStateToQml(threadState);
}

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


