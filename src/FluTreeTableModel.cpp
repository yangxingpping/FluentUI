#include "FluTreeTableModel.h"

FluTreeTableModel::FluTreeTableModel(QObject *parent)
    : QAbstractItemModel(parent), rootItem(new MyTreeItem)
{
}

QModelIndex FluTreeTableModel::index(int row, int column, const QModelIndex &parent) const
{
    if(!hasIndex(row, column, parent))
        return QModelIndex();
    MyTreeItem *parentItem = getItem(parent);
    auto childPtr = parentItem->subItems.at(row);
    if (childPtr){
        return createIndex(row, column, childPtr.get());
    }else{
        return QModelIndex();
    }
}

QModelIndex FluTreeTableModel::parent(const QModelIndex &index) const
{
    if(!index.isValid()){
        return QModelIndex();
    }
    MyTreeItem *childItem = getItem(index);
    auto parentPtr = childItem->parentItem;
    if(!parentPtr || parentPtr == rootItem){
        return QModelIndex();
    }
    return createIndex(parentPtr.get()->row, 0, parentPtr.get());
}

int FluTreeTableModel::rowCount(const QModelIndex &parent) const
{
    MyTreeItem *parentItem = getItem(parent);
    return parentItem->subItems.size();
}

int FluTreeTableModel::columnCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 3;
}

QVariant FluTreeTableModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid()){
        return QVariant();
    }
    MyTreeItem *item = getItem(index);
    if(role == Qt::DisplayRole){
        //TreeView继承自TableView，所以可以通过不同的column来取单元格数据
        role = Qt::UserRole + index.column();
    }
    switch (role) {
    case NameRole: return item->name;
    case DetailRole: return item->detail;
    case FileSize: return item->fileSize;
    default: break;
    }
    return QVariant();
}

QHash<int, QByteArray> FluTreeTableModel::roleNames() const
{
    QHash<int, QByteArray> names = QAbstractItemModel::roleNames();
    names.insert(QHash<int, QByteArray>{
                     {NameRole, "name"}
                     ,{DetailRole, "detail"}
                         ,{FileSize, "FileSize"}
                 });
    return names;
}

void FluTreeTableModel::resetItems()
{
    beginResetModel();
    for(int i=0; i<10; i++)
    {
        QSharedPointer<MyTreeItem> lv1{new MyTreeItem};
        lv1->parentItem = rootItem;
        rootItem->subItems.append(lv1);
        lv1->row = i;
        lv1->name = QString("lv1-%1").arg(i);
        lv1->detail = QString("detail-%1").arg(i);
        lv1->fileSize = QString("size-%1").arg(i);
        for(int j=0; j<10; j++)
        {
            QSharedPointer<MyTreeItem> lv2{new MyTreeItem};
            lv2->parentItem = lv1;
            lv1->subItems.append(lv2);
            lv2->row = j;
            lv2->name = QString("lv2-%1-%2").arg(i).arg(j);
            lv2->detail = QString("detail-%1-%2").arg(i).arg(j);
			for (int k = 0; k < 2; k++)
			{
				QSharedPointer<MyTreeItem> lv3{ new MyTreeItem };
				lv3->parentItem = lv1;
				lv2->subItems.append(lv3);
				lv3->row = k;
				lv3->name = QString("lv3-%1-%2").arg(j).arg(k);
				lv3->detail = QString("detail-%1-%2").arg(j).arg(k);
                lv3->fileSize = QString("size-%1-%2").arg(j).arg(k);
			}
        }
    }
    endResetModel();
    qDebug()<<__FUNCTION__<<rowCount()<<columnCount();
}

MyTreeItem *FluTreeTableModel::getItem(const QModelIndex &idx) const
{
    if(idx.isValid()){
        MyTreeItem *item = static_cast<MyTreeItem*>(idx.internalPointer());
        if(item){
            return item;
        }
    }
    return rootItem.get();
}

