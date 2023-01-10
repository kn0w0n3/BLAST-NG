#include "readfiledatathread.h"

ReadFileDataThread::ReadFileDataThread(QThread *parent) : QThread(parent){
selectFile();
}

void ReadFileDataThread::run(){
    emit loadDataStarted("Loading File Data...");
    QFile fileLocation(file);
    if (fileLocation.open(QIODevice::ReadOnly)){
        //qDebug() << "In file read funtion if statement";
        QTextStream fileContentsStream(&fileLocation);
        while (!fileContentsStream.atEnd()){
            fileContents = fileContentsStream.readAll();
        }
        fileLocation.close();
        emit fileData(fileContents);
    }
    emit loadDataStoped("Load Data Completed...");
    fileContents = "";
}

void ReadFileDataThread::selectFile(){
    qDebug() << "In file read funtion";
    file = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select Directory"), "/home");

    QFileInfo fileInfo(file);
    fileName = fileInfo.fileName();
    filePath = fileInfo.filePath();  
    fileSize = QString::number(fileInfo.size());

    qDebug() << "The File name is: " + fileName;
    qDebug() << "The file path is: " + filePath;
    qDebug() << "The file size is: " + fileSize + " bytes";
}
