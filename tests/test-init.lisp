;;;; -*- Mode: LISP; Syntax: ANSI-Common-Lisp; Base: 10 -*-
;;;; ======================================================================
;;;; File:    test-init.lisp
;;;; Author:  Marcus Pearce <m.t.pearce@city.ac.uk>
;;;; Created: 30/03/2004
;;;; Updated: $Id$
;;;; ======================================================================
;;;;
;;;; Description ==========================================================
;;;; ======================================================================
;;;;
;;;; Initialisation utilities for running regression tests on CLSQL. 
;;;;
;;;; ======================================================================

(in-package #:clsql-tests)

(defvar *test-database-type* nil)
(defvar *test-database-server* "")
(defvar *test-database-name* "")
(defvar *test-database-user* "")
(defvar *test-database-password* "")

(defclass thing ()
  ((extraterrestrial :initform nil :initarg :extraterrestrial)))

(def-view-class person (thing)
  ((height :db-kind :base :accessor height :type float :nulls-ok t
           :initarg :height)
   (married :db-kind :base :accessor married :type boolean :nulls-ok t
            :initarg :married)
   (birthday :nulls-ok t :type clsql-base:wall-time :initarg :birthday)
   (hobby :db-kind :virtual :initarg :hobby :initform nil)))
  
(def-view-class employee (person)
  ((emplid
    :db-kind :key
    :db-constraints :not-null
    :nulls-ok nil
    :type integer
    :initarg :emplid)
   (groupid
    :db-kind :key
    :db-constraints :not-null
    :nulls-ok nil
    :type integer
    :initarg :groupid)
   (first-name
    :accessor first-name
    :type (string 30)
    :initarg :first-name)
   (last-name
    :accessor last-name
    :type (string 30)
    :initarg :last-name)
   (email
    :accessor employee-email
    :type (string 100)
    :nulls-ok t
    :initarg :email)
   (companyid
    :type integer)
   (company
    :accessor employee-company
    :db-kind :join
    :db-info (:join-class company
			  :home-key companyid
			  :foreign-key companyid
			  :set nil))
   (managerid
    :type integer
    :nulls-ok t)
   (manager
    :accessor employee-manager
    :db-kind :join
    :db-info (:join-class employee
			  :home-key managerid
			  :foreign-key emplid
			  :set nil)))
  (:base-table employee))

(def-view-class company ()
  ((companyid
    :db-type :key
    :db-constraints :not-null
    :type integer
    :initarg :companyid)
   (groupid
    :db-type :key
    :db-constraints :not-null
    :type integer
    :initarg :groupid)
   (name
    :type (string 100)
    :initarg :name)
   (presidentid
    :type integer)
   (president
    :reader president
    :db-kind :join
    :db-info (:join-class employee
			  :home-key presidentid
			  :foreign-key emplid
			  :set nil))
   (employees
    :reader company-employees
    :db-kind :join
    :db-info (:join-class employee
			  :home-key (companyid groupid)
			  :foreign-key (companyid groupid)
			  :set t)))
  (:base-table company))

(defparameter company1 (make-instance 'company
                                      :companyid 1
                                      :groupid 1
                                      :name "Widgets Inc."))

(defparameter employee1 (make-instance 'employee
                                       :emplid 1
                                       :groupid 1
                                       :married t 
                                       :height (1+ (random 1.00))
                                       :birthday (clsql-base:get-time)
                                       :first-name "Vladamir"
                                       :last-name "Lenin"
                                       :email "lenin@soviet.org"))
			      
(defparameter employee2 (make-instance 'employee
			       :emplid 2
                               :groupid 1
			       :height (1+ (random 1.00))
                               :married t 
                               :birthday (clsql-base:get-time)
                               :first-name "Josef"
			       :last-name "Stalin"
			       :email "stalin@soviet.org"))

(defparameter employee3 (make-instance 'employee
			       :emplid 3
                               :groupid 1
			       :height (1+ (random 1.00))
                               :married t 
                               :birthday (clsql-base:get-time)
                               :first-name "Leon"
			       :last-name "Trotsky"
			       :email "trotsky@soviet.org"))

(defparameter employee4 (make-instance 'employee
			       :emplid 4
                               :groupid 1
			       :height (1+ (random 1.00))
                               :married nil
                               :birthday (clsql-base:get-time)
                               :first-name "Nikita"
			       :last-name "Kruschev"
			       :email "kruschev@soviet.org"))

(defparameter employee5 (make-instance 'employee
			       :emplid 5
                               :groupid 1
                               :married nil
			       :height (1+ (random 1.00))
                               :birthday (clsql-base:get-time)
                               :first-name "Leonid"
			       :last-name "Brezhnev"
			       :email "brezhnev@soviet.org"))

(defparameter employee6 (make-instance 'employee
			       :emplid 6
                               :groupid 1
                               :married nil
			       :height (1+ (random 1.00))
                               :birthday (clsql-base:get-time)
                               :first-name "Yuri"
			       :last-name "Andropov"
			       :email "andropov@soviet.org"))

(defparameter employee7 (make-instance 'employee
                                 :emplid 7
                                 :groupid 1
                                 :height (1+ (random 1.00))
                                 :married nil
                                 :birthday (clsql-base:get-time)
                                 :first-name "Konstantin"
                                 :last-name "Chernenko"
                                 :email "chernenko@soviet.org"))

(defparameter employee8 (make-instance 'employee
                                 :emplid 8
                                 :groupid 1
                                 :height (1+ (random 1.00))
                                 :married nil
                                 :birthday (clsql-base:get-time)
                                 :first-name "Mikhail"
                                 :last-name "Gorbachev"
                                 :email "gorbachev@soviet.org"))

(defparameter employee9 (make-instance 'employee
                                 :emplid 9
                                 :groupid 1 
                                 :married nil
                                 :height (1+ (random 1.00))
                                 :birthday (clsql-base:get-time)
                                 :first-name "Boris"
                                 :last-name "Yeltsin"
                                 :email "yeltsin@soviet.org"))

(defparameter employee10 (make-instance 'employee
                                  :emplid 10
                                  :groupid 1
                                  :married nil
                                  :height (1+ (random 1.00))
                                  :birthday (clsql-base:get-time)
                                  :first-name "Vladamir"
                                  :last-name "Putin"
                                  :email "putin@soviet.org"))

(defun test-database-connection-spec ()
  (let ((dbserver *test-database-server*)
        (dbname *test-database-name*)
        (dbpassword *test-database-password*)
        (dbtype *test-database-type*)
        (username *test-database-user*))
    (case dbtype
      (:postgresql
       `("" ,dbname ,username ,dbpassword))
      (:postgresql-socket
       `(,dbserver ,dbname ,username ,dbpassword))
      (:mysql
       `("" ,dbname ,username ,dbpassword))
      (:sqlite
       `(,dbname))
      (:oracle
       `(,username ,dbpassword ,dbname))
      (t
       (error "Unrecognized database type: ~A" dbtype)))))

(defun test-connect-to-database (database-type)
  (setf *test-database-type* database-type)
  ;; Connect to the database
  (clsql:connect (test-database-connection-spec)
                :database-type database-type
                :make-default t
                :if-exists :old))

(defmacro with-ignore-errors (&rest forms)
  `(progn
     ,@(mapcar
	(lambda (x) (list 'ignore-errors x))
	forms)))

(defun test-initialise-database ()
    ;; Delete the instance records
  (with-ignore-errors 
    (clsql:delete-instance-records company1)
    (clsql:delete-instance-records employee1)
    (clsql:delete-instance-records employee2)
    (clsql:delete-instance-records employee3)
    (clsql:delete-instance-records employee4)
    (clsql:delete-instance-records employee5)
    (clsql:delete-instance-records employee6)
    (clsql:delete-instance-records employee7)
    (clsql:delete-instance-records employee8)
    (clsql:delete-instance-records employee9)
    (clsql:delete-instance-records employee10)
    ;; Drop the required tables if they exist 
    (clsql:drop-view-from-class 'employee)
    (clsql:drop-view-from-class 'company))
  ;; Create the tables for our view classes
  (clsql:create-view-from-class 'employee)
  (clsql:create-view-from-class 'company)
  ;; Lenin manages everyone
  (clsql:add-to-relation employee2 'manager employee1)
  (clsql:add-to-relation employee3 'manager employee1)
  (clsql:add-to-relation employee4 'manager employee1)
  (clsql:add-to-relation employee5 'manager employee1)
  (clsql:add-to-relation employee6 'manager employee1)
  (clsql:add-to-relation employee7 'manager employee1)
  (clsql:add-to-relation employee8 'manager employee1)
  (clsql:add-to-relation employee9 'manager employee1)
  (clsql:add-to-relation employee10 'manager employee1)
  ;; Everyone works for Widgets Inc.
  (clsql:add-to-relation company1 'employees employee1)
  (clsql:add-to-relation company1 'employees employee2)
  (clsql:add-to-relation company1 'employees employee3)
  (clsql:add-to-relation company1 'employees employee4)
  (clsql:add-to-relation company1 'employees employee5)
  (clsql:add-to-relation company1 'employees employee6)
  (clsql:add-to-relation company1 'employees employee7)
  (clsql:add-to-relation company1 'employees employee8)
  (clsql:add-to-relation company1 'employees employee9)
  (clsql:add-to-relation company1 'employees employee10)
  ;; Lenin is president of Widgets Inc.
  (clsql:add-to-relation company1 'president employee1)
  ;; store these instances 
  (clsql:update-records-from-instance employee1)
  (clsql:update-records-from-instance employee2)
  (clsql:update-records-from-instance employee3)
  (clsql:update-records-from-instance employee4)
  (clsql:update-records-from-instance employee5)
  (clsql:update-records-from-instance employee6)
  (clsql:update-records-from-instance employee7)
  (clsql:update-records-from-instance employee8)
  (clsql:update-records-from-instance employee9)
  (clsql:update-records-from-instance employee10)
  (clsql:update-records-from-instance company1))

(defun run-tests (backend)
  (format t "~&Running CLSQL tests with ~A backend.~%" backend)
  (test-connect-to-database backend)
  (test-initialise-database)
  (rtest:do-tests))


