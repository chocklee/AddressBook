//
//  ViewController.m
//  AddressBook
//
//  Created by chocklee on 2016/10/10.
//  Copyright © 2016年 北京超信. All rights reserved.
//

#import "ViewController.h"

// 导入头文件
/*AddressBook.framework框架 iOS9被弃用*/
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>

#import <ContactsUI/CNContactPickerViewController.h>

@interface ViewController () <CNContactPickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAddressBook:(UIButton *)sender {
    // 有UI
//    CNContactPickerViewController * contactPickerVC = [[CNContactPickerViewController alloc] init];
//    contactPickerVC.delegate = self;
//    [self presentViewController:contactPickerVC animated:YES completion:nil];
    
    // 无UI
    // 1.判断授权状态
    if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
                // 2.获取联系人仓库
                CNContactStore *store = [[CNContactStore alloc] init];
                // 3.创建联系人信息的请求对象
                NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
                // 4.根据请求key，创建请求对象
                CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
                // 5.发送请求
                [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                    // 6.1获取姓名
                    NSString *givenName = contact.givenName;
                    NSString *familyName = contact.familyName;
                    NSLog(@"%@%@",familyName,givenName);
                    
                    // 6.2获取电话
                    NSArray *phoneArray = contact.phoneNumbers;
                    for (CNLabeledValue *labelValue in phoneArray) {
                        CNPhoneNumber *number = labelValue.value;
                        NSLog(@"%@",number.stringValue);
                    }
                }];
            } else {
                NSLog(@"授权失败");
            }
        }];
    }
}

#pragma mark - CNContactPickerDelegate
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    
}

// 选中一个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSLog(@"%@",contact);
}

// 选中一个联系人属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    NSLog(@"%@",contactProperty);
}

// 选中多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts {
    NSLog(@"%@",contacts);
}

// 选中一个联系人的多个属性
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties {
    NSLog(@"%@",contactProperties);
}

@end
