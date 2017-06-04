//
//  main.swift
//  Grade_seo_jin_woo
//
//  Created by  서진우 on 2017. 6. 2..
//  Copyright © 2017년  서진우. All rights reserved.
//

import Foundation

class student {
    
    var name : String?
    var average : Double = 0
    var grade : Character?
    
    func mygrade() {
        
        if self.average >= 90 {
            self.grade = "A"
        } else if self.average >= 80 {
            self.grade = "B"
        } else if self.average >= 70 {
            self.grade = "C"
        } else if self.average >= 60 {
            self.grade = "D"
        } else {
            self.grade = "F"
        }
        
    }
    
}

var student_list = [student]()

let pathToRead = "/Users/jinwoo/students.json"
let pathToWrite = "/Users/jinwoo/result.txt"


func writeStringToFile(pathToWrite : String, result : String){
    do {
        try result.write(toFile: pathToWrite, atomically: true, encoding: .utf8)
    } catch let error {
        print("Failed writing to path: \(error)")
    }
}

func jsonParsing(path : String) -> Array<student>
{
    var list = [student]()
    
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let apiDictionary = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        
        
        for row in apiDictionary {
            
            let s = row as! NSDictionary
            
            let name = s["name"] as? String
            let grade = s["grade"] as! NSDictionary
            
            let stu = student()
            
            stu.name = name
            
            for (_, value) in grade {
                
                let score = value as! Double
                stu.average += score / Double(grade.count)
                
            }
            
            stu.mygrade()
            
            list.append(stu)
            
        }
        
        list.sort(by: {(s1 : student, s2 : student) in return s1.name! < s2.name! })
        
    } catch let error {
        print(error.localizedDescription)
    }
    
    return list
}

func outputResult(student_list : Array<student>) -> String {
    
    var total_ave : Double = 0
    var student_pass = [String]()
    var result = ""
    
    for student in student_list {
        
        total_ave += student.average / Double(student_list.count)
    }
    
    let total_ave_string = String(format: "%.2f", total_ave)
    
    result = "성적결과표\n\n전체 평균 : \(total_ave_string)\n\n개인별 학점\n\n"
    
    
    for student in student_list {
        
        result += "\(student.name!)\t\t: \(student.grade!)\n"
        
    }
    
    result += "\n수료생\n"
    
    for student in student_list {
        if student.average >= 70 {
            student_pass.append(student.name!)
        }
    }
    
    student_pass.sort()
    let count = student_pass.count
    
    for i in 0..<count{
        if i < count-1 {
            result += "\(student_pass[i]), "
        } else {
            result += "\(student_pass[i])\n"
        }
    }
    
    return result
}

student_list = jsonParsing(path: pathToRead)
writeStringToFile(pathToWrite: pathToWrite, result: outputResult(student_list: student_list))

