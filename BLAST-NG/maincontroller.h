#ifndef MAINCONTROLLER_H
#define MAINCONTROLLER_H

#include <QObject>
#include <QWidget>

//File Ops Libs
#include <QFile>
#include <QFileInfo>
#include <QFileDialog>

#include <QDebug>

class MainController:  public QWidget{
    Q_OBJECT

public:
    MainController(QWidget *parent = nullptr);

signals:
    void selectedFileDataToQml(QString _fileContents);


public slots:
    void selectAFile();

private:
    QString fileName;
    QString filePath;
    QString fileContents = "";

};

#endif // MAINCONTROLLER_H
