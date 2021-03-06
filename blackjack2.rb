require_relative 'deck'

class Blackjack

  attr_accessor :player, :dealer, :deck

  def initialize
    self.deck = Deck.new
  end

    def play
      p "Time to play, play like your life depends on it, because it just might!"
      STDIN.gets.chomp
      draw_cards
      unless blackjack(dealer)
      player_turn
      dealer_turn
      ending
      play_again
      end
    end

    def draw_cards
      @deck = Deck.new
      self.dealer = deck.cards.shift(2)
      self.player = deck.cards.shift(2)
      starting_score
    end

    def player_turn
      if blackjack(player)
        beg_winner
      else puts "Would you like to [h] or [s]?"
        answer = STDIN.gets.chomp
          if answer == "h"
            hit_me_player
            puts "You now have #{player.map{|card| "#{card.face} #{card.suit}" }.join(" and ")}, for a total of #{player_score}"
            if busted_yo(player)
              puts "Wamp, wamp, you busted"
              play_again
            elsif blackjack(player)
              puts "Blackjack, you are a winner!"
              play_again
            else
              player_turn
            end
        end
      end
    end


    def dealer_turn
      unless blackjack(dealer) || busted_yo(dealer)
        until hand_value(dealer) >= 16
          hit_me_dealer
          if blackjack(dealer)
            puts "Blackjack for the dealer, dealer wins!"
            play_again
          else busted_yo(dealer)
            puts "Dealer busted, you win!"
            play_again
          end
        end
      end
    end

    def ending
      if six_win(player)
        puts "OMGROFLCOPTER you get an auto win, because that's pretty freakin rare!"
      elsif hand_value(player) > hand_value(dealer)
        puts "You win!"
      elsif hand_value(player) < hand_value(dealer)
        puts "You lose, and the robots are coming for you!"
      else
        if player.length > dealer.length
          puts "You win based on length, heh."
        elsif player.length < dealer.length
          puts "You lose based on length, even more heh"
        else
          puts "Okay, you tied in score and length, I guess that means you win."
        end
      end
    end

    def play_again
      puts "Would you like to play again [y] or [n]?"
      answer = STDIN.gets.chomp
      if answer == "y"
        Game.new.play
      else
        puts "Thanks for playing!"
      end
    end

    def starting_score
      player_score = player.map{|card| card.value}.inject(:+)
      dealer_score = dealer.map{|card| card.value}.inject(:+)
      puts "You have #{player.map{|card| "#{card.face} #{card.suit}" }.join(" and ")}, for a total of #{player_score}"
      puts "The dealer is showing #{dealer.first.face} of #{dealer[0].suit}"
    end

    def player_score
      self.player.inject(0){|sum, card| sum + card.value}
    end

    def dealer_score
      self.dealer.inject(0){|sum, card| sum + card.value}
    end

    def hand_value(hand)
      hand.inject(0){|sum, card| sum + card.value }
    end

    def blackjack(hand)
      hand.length == 2 && hand_value(hand) == 21
    end

    def busted_yo(hand)
      hand_value(hand) > 21
    end

    def hit_me_player
      self.player << deck.draw
    end

    def hit_me_dealer
      self.dealer << deck.draw
    end

    def beg_winner
      p "You got a blackjack without even trying, you are just that awesome!"
    end

    def six_win(hand)
      hand.length >= 6 && hand_value(hand) <= 21
    end


end

Blackjack.new.play
