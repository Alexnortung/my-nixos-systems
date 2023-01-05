rec {
  boat = ./keys/alexander_boat.pub;
  steve = ./keys/alexander_steve.pub;
  spider = ./keys/alexander_spider.pub;
  end = ./keys/end.rsa.pub;
  
  spider_system = ./keys/spider.rsa.pub;

  deployers = [
    boat
    steve
    spider
  ];

  laptops = [
    boat
    spider
  ];

  all = [
    boat
    steve
    spider
    end
  ];

  getKey = file: builtins.readFile file;
  getKeys = files: builtins.map (file: getKey file) files;
}
