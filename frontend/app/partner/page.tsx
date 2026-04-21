'use client';

import { useState, useEffect } from 'react';

export default function PartnerDashboard() {
  const [partnerData, setPartnerData] = useState({
    referralCode: '',
    totalEarned: '0',
    totalVolume: '0',
    feeShareRate: '0',
    tier: 'Bronze',
    isActive: false,
  });

  const [recentReferrals, setRecentReferrals] = useState<Array<{
    user: string;
    volume: string;
    earned: string;
    date: string;
  }>>([]);

  useEffect(() => {
    fetchPartnerData();
  }, []);

  const fetchPartnerData = async () => {
    setPartnerData({
      referralCode: 'KYBERS2024',
      totalEarned: '12.5 ETH',
      totalVolume: '$2,450,000',
      feeShareRate: '0.30%',
      tier: 'Gold',
      isActive: true,
    });

    setRecentReferrals([
      { user: '0x1234...5678', volume: '$50,000', earned: '0.15 ETH', date: '2024-01-15' },
      { user: '0x8765...4321', volume: '$75,000', earned: '0.225 ETH', date: '2024-01-14' },
      { user: '0x9999...1111', volume: '$100,000', earned: '0.30 ETH', date: '2024-01-13' },
    ]);
  };

  return (
    <div className="min-h-screen bg-[#0a0e27] text-white p-8">
      <div className="max-w-7xl mx-auto">
        <div className="mb-8">
          <h1 className="text-4xl font-bold bg-gradient-to-r from-[#00fff9] to-[#b537f2] bg-clip-text text-transparent">
            Partner Dashboard
          </h1>
          <p className="text-gray-400 mt-2">Track your referral earnings and performance</p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#00fff9]/30 rounded-2xl p-6 hover:border-[#00fff9] transition-all">
            <div className="text-[#00fff9] text-sm mb-2">Total Earned</div>
            <div className="text-3xl font-bold">{partnerData.totalEarned}</div>
          </div>

          <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#b537f2]/30 rounded-2xl p-6 hover:border-[#b537f2] transition-all">
            <div className="text-[#b537f2] text-sm mb-2">Referral Volume</div>
            <div className="text-3xl font-bold">{partnerData.totalVolume}</div>
          </div>

          <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#ff006e]/30 rounded-2xl p-6 hover:border-[#ff006e] transition-all">
            <div className="text-[#ff006e] text-sm mb-2">Revenue Share Rate</div>
            <div className="text-3xl font-bold">{partnerData.feeShareRate}</div>
          </div>

          <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#39ff14]/30 rounded-2xl p-6 hover:border-[#39ff14] transition-all">
            <div className="text-[#39ff14] text-sm mb-2">Partner Tier</div>
            <div className="text-3xl font-bold">{partnerData.tier}</div>
          </div>
        </div>

        <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#00fff9]/30 rounded-2xl p-6 mb-8">
          <h2 className="text-2xl font-bold mb-4 text-[#00fff9]">Your Referral Code</h2>
          <div className="flex items-center gap-4">
            <div className="flex-1 bg-[#0a0e27] border border-[#00fff9]/50 rounded-lg p-4 font-mono text-2xl">
              {partnerData.referralCode}
            </div>
            <button
              onClick={() => navigator.clipboard.writeText(partnerData.referralCode)}
              className="px-6 py-3 bg-gradient-to-r from-[#b537f2] to-[#ff006e] rounded-lg font-semibold hover:scale-105 transition-all"
            >
              Copy Code
            </button>
          </div>
        </div>

        <div className="bg-[#1a1f3a]/60 backdrop-blur-lg border border-[#ff006e]/30 rounded-2xl p-6">
          <h2 className="text-2xl font-bold mb-4 text-[#ff006e]">Recent Referrals</h2>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-[#ff006e]/30">
                  <th className="text-left py-3 px-4">User</th>
                  <th className="text-left py-3 px-4">Volume</th>
                  <th className="text-left py-3 px-4">Earned</th>
                  <th className="text-left py-3 px-4">Date</th>
                </tr>
              </thead>
              <tbody>
                {recentReferrals.map((referral, index) => (
                  <tr key={index} className="border-b border-[#ff006e]/10 hover:bg-[#0a0e27]/50">
                    <td className="py-3 px-4 font-mono">{referral.user}</td>
                    <td className="py-3 px-4">{referral.volume}</td>
                    <td className="py-3 px-4 text-[#39ff14]">{referral.earned}</td>
                    <td className="py-3 px-4 text-gray-400">{referral.date}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
