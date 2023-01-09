#include "maincontroller.h"

MainController::MainController(QWidget *parent) : QWidget(parent){

}

void MainController::selectAFile(){
    qDebug() << "In file read funtion";
    QString file = QFileDialog::getOpenFileName(Q_NULLPTR, tr("Select Directory"), "/home");
    QFileInfo fileInfo(file);
    fileName = fileInfo.fileName();
    QFile fileLocation(file);
    filePath = fileInfo.filePath();

    if (fileLocation.open(QIODevice::ReadOnly)){
        //qDebug() << "In file read funtion if statement";
        QTextStream fileContentsStream(&fileLocation);
        while (!fileContentsStream.atEnd()){
            fileContents = fileContentsStream.readAll();
        }
        fileLocation.close();
        //qDebug() << fileContents;
        //emit gBankFileData_T(gBankFileData);
        //fileContents = "";
        emit selectedFileDataToQml(fileContents);
    }
}


