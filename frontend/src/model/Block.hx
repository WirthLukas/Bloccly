package model;

import pattern.observer.Observable;

using pattern.observer.ObservableExtender;

class Block implements Observable {
    
    public function new() {
        
    }
    
    public function no() {
        this.notify();
    }
}