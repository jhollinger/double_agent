require 'yaml'

module DoubleAgent
  # 
  # Map browser/os ids to names, families and icons
  # 
  DATA = YAML.load_file(File.expand_path('../../../data/mappings.yml', __FILE__))
  BROWSER_TREE = YAML.load_file(File.expand_path('../../../data/browser_tree.yml', __FILE__))
  OS_TREE = YAML.load_file(File.expand_path('../../../data/os_tree.yml', __FILE__))

  BROWSERS = DATA['browsers']
  BROWSER_FAMILIES = DATA['browser_families']
  BROWSER_ICONS = BROWSER_FAMILIES
  OSES = DATA['oses']
  OS_FAMILIES = DATA['os_families']
  OS_ICONS = DATA['os_families']

  # 
  # Methods for getting browser/os names, families, and icons either by
  # passing a browser/os id symbol or a user agent string.
  # 

  def self.browser(agent)
    BROWSERS[agent.is_a?(Symbol) ? agent : browser_sym(agent)]
  end

  def self.browser_family(agent)
    BROWSERS[BROWSER_FAMILIES[agent.is_a?(Symbol) ? agent : browser_sym(agent)]]
  end

  def self.browser_icon(agent)
    BROWSER_ICONS[agent.is_a?(Symbol) ? agent : browser_sym(agent)]
  end

  def self.os(agent)
    OSES[agent.is_a?(Symbol) ? agent : os_sym(agent)]
  end

  def self.os_family(agent)
    OSES[OS_FAMILIES[agent.is_a?(Symbol) ? agent : os_sym(agent)]]
  end

  def self.os_icon(agent)
    OS_ICONS[agent.is_a?(Symbol) ? agent : os_sym(agent)]
  end

  def self.browser_family_sym(agent)
    BROWSER_FAMILIES[agent.is_a?(Symbol) ? agent : browser_sym(agent)]
  end

  def self.os_family_sym(agent)
    OS_FAMILIES[agent.is_a?(Symbol) ? agent : os_sym(agent)]
  end

  def self.browser_sym(user_agent)
  end

  def self.os_sym(user_agent)
  end

  def self.build_tree!(method_name, branches)
    str = build_case(branches)
    # Pull a browser id symbol from a user agent string
    module_eval "def self.#{method_name}(user_agent); #{str}; end"
  end

  private

  def self.build_case(items, else_str='unknown', level=0)
    indent = ''; level.times { indent << '  ' }
    str = "#{indent}case user_agent\n"
    items.each do |b|
      if b['members']
        level += 1
        str << "#{indent}  when %r{#{b['regex']}}i\n"
        str << build_case(b['members'], b['sym'], level)
      else
        str << "#{indent}  when %r{#{b['regex']}}i then :#{b['sym']}\n"
      end
    end
    str << "#{indent}  else :#{else_str}\n" if else_str
    str << "#{indent}end\n"
    str
  end
end

DoubleAgent.build_tree! 'browser_sym', DoubleAgent::BROWSER_TREE
DoubleAgent.build_tree! 'os_sym', DoubleAgent::OS_TREE
